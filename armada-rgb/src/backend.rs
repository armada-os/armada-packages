//! Hardware backends for RGB lighting.

use crate::{ColorCorrection, LightingConfig};
use anyhow::{bail, Context, Result};
use std::collections::HashSet;
use std::fs::{self, File, OpenOptions};
use std::io::Write;
use std::time::Duration;
use std::path::{Path, PathBuf};

pub enum LightingBackend {
    Channels(ChannelBackend),
    Multicolor(MulticolorBackend),
    Uart(UartBackend),
    Unsupported(String),
}

impl LightingBackend {
    pub fn apply(&self, config: &LightingConfig) -> Result<()> {
        match self {
            Self::Channels(backend) => backend.apply(config),
            Self::Multicolor(backend) => backend.apply(config),
            Self::Uart(backend) => backend.apply(config),
            Self::Unsupported(reason) => bail!("{reason}"),
        }
    }

    pub fn unsupported_reason(&self) -> Option<&str> {
        match self {
            Self::Channels(_) | Self::Multicolor(_)  | Self::Uart(_) => None,
            Self::Unsupported(reason) => Some(reason),
        }
    }

    pub(crate) fn default_correction(&self) -> Option<ColorCorrection> {
        match self {
            Self::Channels(backend) => backend.correction.clone(),
            Self::Multicolor(backend) => backend.correction.clone(),
            Self::Uart(backend) => backend.correction.clone(),
            Self::Unsupported(_) => None,
        }
    }
}

pub struct ChannelBackend {
    root: PathBuf,
    targets: Vec<String>,
    correction: Option<ColorCorrection>,
}

impl ChannelBackend {
    pub fn new(root: PathBuf, targets: Vec<String>) -> Self {
        Self {
            root,
            targets,
            correction: None,
        }
    }

    pub(crate) fn with_correction(mut self, correction: Option<ColorCorrection>) -> Self {
        self.correction = correction;
        self
    }

    fn apply(&self, config: &LightingConfig) -> Result<()> {
        let mut targets: Vec<PreparedChannel> = self.prepare(config)?;

        if let Err(error) = write_channels(&mut targets) {
            blank_channels_best_effort(&targets);
            return Err(error);
        }
        Ok(())
    }

    fn prepare(&self, config: &LightingConfig) -> Result<Vec<PreparedChannel>> {
        let [red, green, blue]: [u8; 3] = corrected_rgb(config, self.correction.as_ref());
        let mut channels: Vec<(String, u8)> = Vec::new();

        for target in &self.targets {
            let (channel, name): (&str, &str) = target
                .split_once('=')
                .with_context(|| format!("invalid RGB channel target '{target}'"))?;
            let value: u8 = match channel {
                "red" => red,
                "green" => green,
                "blue" => blue,
                _ => bail!("invalid RGB channel '{channel}'"),
            };
            channels.push((name.into(), value));
        }

        let names: Vec<String> = channels.iter().map(|(name, _)| name.clone()).collect();
        validate_names(&names)?;

        let mut targets: Vec<PreparedChannel> = Vec::new();

        for (name, channel) in channels {
            let path: PathBuf = self.root.join(&name);
            let brightness_path: PathBuf = path.join("brightness");
            let brightness: File = OpenOptions::new()
                .write(true)
                .open(&brightness_path)
                .with_context(|| format!("open {name} brightness"))?;
            let value: u32 = if config.enabled {
                let maximum: u32 = read_maximum(&path.join("max_brightness"))?;
                scale(config.brightness, gamma(channel, maximum))
            } else {
                0
            };

            targets.push(PreparedChannel {
                name,
                brightness_path,
                brightness,
                value: value.to_string(),
            });
        }
        Ok(targets)
    }
}

pub struct MulticolorBackend {
    root: PathBuf,
    targets: Vec<String>,
    correction: Option<ColorCorrection>,
}

impl MulticolorBackend {
    pub fn new(root: PathBuf, targets: Vec<String>) -> Self {
        Self {
            root,
            targets,
            correction: None,
        }
    }

    pub(crate) fn with_correction(mut self, correction: Option<ColorCorrection>) -> Self {
        self.correction = correction;
        self
    }

    fn apply(&self, config: &LightingConfig) -> Result<()> {
        let mut targets: Vec<PreparedTarget> = self.prepare(config)?;

        if !config.enabled {
            return blank(&mut targets);
        }

        if let Err(error) = write_colors(&mut targets) {
            blank_best_effort(&mut targets);
            return Err(error);
        }
        if let Err(error) = write_brightness(&mut targets) {
            blank_best_effort(&mut targets);
            return Err(error);
        }
        Ok(())
    }

    fn prepare(&self, config: &LightingConfig) -> Result<Vec<PreparedTarget>> {
        validate_names(&self.targets)?;
        let mut targets: Vec<PreparedTarget> = Vec::new();
        let rgb: [u8; 3] = corrected_rgb(config, self.correction.as_ref());

        for name in &self.targets {
            let path: PathBuf = self.root.join(name);
            let brightness_path: PathBuf = path.join("brightness");
            let blank: File = OpenOptions::new()
                .write(true)
                .open(&brightness_path)
                .with_context(|| format!("open {name} brightness"))?;

            if !config.enabled {
                targets.push(PreparedTarget {
                    name: name.clone(),
                    brightness_path,
                    blank,
                    brightness: None,
                    color: None,
                });
                continue;
            }

            let order: Vec<String> = read_order(&path.join("multi_index"))?;
            let maximum: u32 = read_maximum(&path.join("max_brightness"))?;
            let values: Vec<String> = order
                .iter()
                .map(|channel| channel_value(channel, rgb, maximum).to_string())
                .collect();
            let intensity: File = OpenOptions::new()
                .write(true)
                .open(path.join("multi_intensity"))
                .with_context(|| format!("open {name} multi_intensity"))?;
            let brightness: File = OpenOptions::new()
                .write(true)
                .open(&brightness_path)
                .with_context(|| format!("open {name} brightness"))?;
            let brightness_value: String = scale(config.brightness, maximum).to_string();

            targets.push(PreparedTarget {
                name: name.clone(),
                brightness_path,
                blank,
                brightness: Some((brightness, brightness_value)),
                color: Some((intensity, values.join(" "))),
            });
        }
        Ok(targets)
    }
}

pub struct UartBackend {
    device: PathBuf,
    baud_rate: u32,
    correction: Option<ColorCorrection>,
}

impl UartBackend {
    pub fn new(device: PathBuf, baud_rate: u32) -> Self {
        Self {
            device,
            baud_rate,
            correction: None,
        }
    }

    pub(crate) fn with_correction(
        mut self,
        correction: Option<ColorCorrection>,
    ) -> Self {
        self.correction = correction;
        self
    }

    fn apply(&self, config: &LightingConfig) -> Result<()> {
        let [red, green, blue] = corrected_rgb(config, self.correction.as_ref());
        let brightness = if config.enabled {
            config.brightness
        } else {
            0
        };

        let frame = self.build_frame(red, green, blue, brightness);

        let mut device = OpenOptions::new()
            .write(true)
            .open(&self.device)
            .with_context(|| format!("open {}", self.device.display()))?;

        configure_uart(&self.device, self.baud_rate)?;

        for _ in 0..3 {
            device.write_all(&frame)?;
            device.flush()?;
            std::thread::sleep(Duration::from_millis(40));
        }

        Ok(())
    }

    fn build_frame(&self, red: u8, green: u8, blue: u8, brightness: u8) -> [u8; 27] {
        let mut frame = [0xF7, 0x00, 0x1C, 0x20, 0x01, 0x80, 0x00, 0x81, 0x00, 0x8B,
                         0x0F, 0x88, red, 0x89, green, 0x8A, blue, 0x86, brightness,
                         0x87, brightness, 0x58, 0x08, 0x45, 0x00, 0x00, 0xED,];

        frame[25] = checksum(&frame[1..25]);
        frame
    }
}

struct PreparedTarget {
    name: String,
    brightness_path: PathBuf,
    blank: File,
    brightness: Option<(File, String)>,
    color: Option<(File, String)>,
}

struct PreparedChannel {
    name: String,
    brightness_path: PathBuf,
    brightness: File,
    value: String,
}

fn checksum(bytes: &[u8]) -> u8 {
    bytes.iter().fold(0u8, |sum, byte| sum.wrapping_add(*byte))
}

fn configure_uart(device: &Path, baud_rate: u32) -> Result<()> {
    std::process::Command::new("stty")
        .arg("-F")
        .arg(device)
        .arg(baud_rate.to_string())
        .args(["-clocal", "-opost", "-isig", "-icanon", "-echo"])
        .status()
        .with_context(|| format!("configure {}", device.display()))?
        .success()
        .then_some(())
        .with_context(|| format!("configure {}", device.display()))
}

fn blank(targets: &mut [PreparedTarget]) -> Result<()> {
    for target in targets {
        write_attr(&mut target.blank, "0")
            .with_context(|| format!("write {} brightness", target.name))?;
    }
    Ok(())
}

fn blank_best_effort(targets: &mut [PreparedTarget]) {
    for target in targets {
        let _ = fs::write(&target.brightness_path, b"0\n");
    }
}

fn blank_channels_best_effort(targets: &[PreparedChannel]) {
    for target in targets {
        let _ = fs::write(&target.brightness_path, b"0\n");
    }
}

fn write_channels(targets: &mut [PreparedChannel]) -> Result<()> {
    for target in targets {
        write_attr(&mut target.brightness, &target.value)
            .with_context(|| format!("write {} brightness", target.name))?;
    }
    Ok(())
}

fn write_colors(targets: &mut [PreparedTarget]) -> Result<()> {
    for target in targets {
        let (file, value) = target.color.as_mut().expect("prepared color");
        write_attr(file, value).with_context(|| format!("write {} color", target.name))?;
    }
    Ok(())
}

fn write_brightness(targets: &mut [PreparedTarget]) -> Result<()> {
    for target in targets {
        let (file, value) = target.brightness.as_mut().expect("prepared brightness");
        write_attr(file, value).with_context(|| format!("write {} brightness", target.name))?;
    }
    Ok(())
}

fn write_attr(file: &mut File, value: &str) -> std::io::Result<()> {
    let output: String = format!("{value}\n");
    file.write_all(output.as_bytes())?;
    file.flush()
}

fn read_order(path: &Path) -> Result<Vec<String>> {
    let input: String =
        fs::read_to_string(path).with_context(|| format!("read {}", path.display()))?;
    let order: Vec<String> = input.split_whitespace().map(str::to_lowercase).collect();
    let channels: HashSet<&str> = order.iter().map(String::as_str).collect();

    if order.len() != 3 || channels != HashSet::from(["red", "green", "blue"]) {
        bail!(
            "{} is not an RGB multi_index: '{}'",
            path.display(),
            input.trim()
        );
    }
    Ok(order)
}

fn read_maximum(path: &Path) -> Result<u32> {
    let input: String =
        fs::read_to_string(path).with_context(|| format!("read {}", path.display()))?;
    let maximum: u32 = input
        .trim()
        .parse()
        .with_context(|| format!("parse {}", path.display()))?;

    if maximum == 0 {
        bail!("{} is zero", path.display());
    }
    Ok(maximum)
}

fn validate_names(targets: &[String]) -> Result<()> {
    let mut seen: HashSet<&String> = HashSet::new();

    if targets.is_empty() {
        bail!("RGB target list is empty");
    }
    for target in targets {
        let valid: bool = !target.is_empty()
            && target
                .bytes()
                .all(|c| c.is_ascii_alphanumeric() || b":_.-".contains(&c))
            && target != "."
            && target != "..";
        if !valid {
            bail!("invalid target name '{target}'");
        }
        if !seen.insert(target) {
            bail!("duplicate target '{target}'");
        }
    }
    Ok(())
}

fn channel_value(channel: &str, [red, green, blue]: [u8; 3], maximum: u32) -> u32 {
    match channel {
        "red" => gamma(red, maximum),
        "green" => gamma(green, maximum),
        "blue" => gamma(blue, maximum),
        _ => unreachable!("validated channel"),
    }
}

fn corrected_rgb(config: &LightingConfig, profile: Option<&ColorCorrection>) -> [u8; 3] {
    let rgb: [u8; 3] = config.rgb();
    let correction: Option<&ColorCorrection> = config.correction.as_ref().or(profile);
    let Some(correction) = correction else {
        return rgb;
    };
    correction.apply(rgb)
}

fn gamma(channel: u8, maximum: u32) -> u32 {
    let value: f64 = f64::from(channel) / 255.0;
    let linear: f64 = if value <= 0.04045 {
        value / 12.92
    } else {
        ((value + 0.055) / 1.055).powf(2.4)
    };
    (linear * f64::from(maximum)).round() as u32
}

fn scale(percent: u8, maximum: u32) -> u32 {
    ((u64::from(percent) * u64::from(maximum) + 50) / 100) as u32
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn scales_channels_and_brightness() {
        assert_eq!(gamma(0, 255), 0);
        assert_eq!(gamma(128, 100), 22);
        assert_eq!(gamma(255, 255), 255);
        assert_eq!(scale(25, 255), 64);
    }

    #[test]
    fn uart_builds_expected_frame() {
        let backend = UartBackend::new(PathBuf::from("/dev/ttyHS0"), 115_200);

        let frame = backend.build_frame(0xFF, 0x00, 0x00, 0x40);

        assert_eq!(
            frame,
            [
                0xF7, 0x00, 0x1C, 0x20, 0x01, 0x80, 0x00, 0x81, 0x00,
                0x8B, 0x0F, 0x88, 0xFF, 0x89, 0x00, 0x8A, 0x00, 0x86,
                0x40, 0x87, 0x40, 0x58, 0x08, 0x45, 0x00, 0xA4, 0xED,
            ]
        );
    }
}
