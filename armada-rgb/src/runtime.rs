use crate::{ChannelBackend, ColorCorrection, LightingBackend, MulticolorBackend};
use anyhow::{bail, Context, Result};
use std::collections::HashMap;
use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;

const CONFIG_PATH: &str = "/etc/armada/rgb.json";
const SYSFS_ROOT: &str = "/sys/class/leds";
const DEVICE_ENV: &str = "/usr/libexec/armada/device-env";

pub(crate) fn from_env() -> (PathBuf, LightingBackend) {
    let config_path: PathBuf = env::var_os("ARMADA_RGB_CONFIG_PATH")
        .map(PathBuf::from)
        .unwrap_or_else(|| CONFIG_PATH.into());
    let sysfs_root: PathBuf = env::var_os("ARMADA_RGB_SYSFS_ROOT")
        .map(PathBuf::from)
        .unwrap_or_else(|| SYSFS_ROOT.into());
    let device_env: PathBuf = env::var_os("ARMADA_RGB_DEVICE_ENV")
        .or_else(|| env::var_os("ARMADA_DEVICE_ENV"))
        .map(PathBuf::from)
        .unwrap_or_else(|| DEVICE_ENV.into());
    let backend_override: Option<String> = env::var("ARMADA_RGB_BACKEND").ok();
    let targets_override: Option<String> = env::var("ARMADA_RGB_TARGETS").ok();
    let correction_override: Option<String> = env::var("ARMADA_RGB_CORRECTION").ok();

    let helper: Result<HashMap<String, String>> =
        if backend_override.is_some() && targets_override.is_some() {
            Ok(HashMap::new())
        } else {
            read_device_env(&device_env)
        };
    let (values, helper_error): (HashMap<String, String>, Option<String>) = match helper {
        Ok(values) => (values, None),
        Err(error) => (HashMap::new(), Some(format!("{error:#}"))),
    };
    let backend_name: String = backend_override
        .or_else(|| values.get("ARMADA_RGB_BACKEND").cloned())
        .unwrap_or_default();
    let target_names: String = targets_override
        .or_else(|| values.get("ARMADA_RGB_TARGETS").cloned())
        .unwrap_or_default();
    let targets: Vec<String> = target_names.split_whitespace().map(str::to_owned).collect();
    let correction: Option<ColorCorrection> = match correction_override
        .or_else(|| values.get("ARMADA_RGB_CORRECTION").cloned())
        .filter(|value| !value.is_empty())
        .map(|value| value.parse())
        .transpose()
    {
        Ok(correction) => correction,
        Err(error) => {
            return (
                config_path,
                LightingBackend::Unsupported(format!("{error:#}")),
            )
        }
    };

    let backend: LightingBackend = match backend_name.as_str() {
        "channels" if !targets.is_empty() => LightingBackend::Channels(
            ChannelBackend::new(sysfs_root, targets).with_correction(correction),
        ),
        "channels" => LightingBackend::Unsupported("device profile has no RGB targets".into()),
        "multicolor" if !targets.is_empty() => LightingBackend::Multicolor(
            MulticolorBackend::new(sysfs_root, targets).with_correction(correction),
        ),
        "multicolor" => LightingBackend::Unsupported("device profile has no RGB targets".into()),
        "" => LightingBackend::Unsupported(
            helper_error.unwrap_or_else(|| "device profile has no RGB backend".into()),
        ),
        backend => LightingBackend::Unsupported(format!("unsupported RGB backend '{backend}'")),
    };

    (config_path, backend)
}

fn read_device_env(path: &Path) -> Result<HashMap<String, String>> {
    let output: std::process::Output = Command::new(path)
        .output()
        .with_context(|| format!("run {}", path.display()))?;
    if !output.status.success() {
        bail!("{} exited with {}", path.display(), output.status);
    }

    let output: String =
        String::from_utf8(output.stdout).context("device-env output is not UTF-8")?;
    parse_device_env(&output)
}

fn parse_device_env(output: &str) -> Result<HashMap<String, String>> {
    const WANTED: [&str; 3] = [
        "ARMADA_RGB_BACKEND",
        "ARMADA_RGB_TARGETS",
        "ARMADA_RGB_CORRECTION",
    ];
    let mut values: HashMap<String, String> = HashMap::new();

    for line in output.lines() {
        let Some((name, value)) = line.split_once('=') else {
            continue;
        };
        if WANTED.contains(&name) {
            values.insert(name.into(), unquote(value)?);
        }
    }
    Ok(values)
}

fn unquote(value: &str) -> Result<String> {
    if matches!(value, "''" | "\"\"") {
        return Ok(String::new());
    }

    let mut result: String = String::new();
    let mut chars: std::str::Chars<'_> = value.chars();
    let mut quote: Option<char> = None;
    while let Some(character) = chars.next() {
        match (quote, character) {
            (None | Some('"'), '\\') => result.push(chars.next().context("trailing escape")?),
            (None, '\'' | '"') => quote = Some(character),
            (Some(open), character) if open == character => quote = None,
            _ => result.push(character),
        }
    }
    if quote.is_some() {
        bail!("unterminated quote in device-env value");
    }
    Ok(result)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_device_env_output() {
        let values: HashMap<String, String> = parse_device_env(
            "ARMADA_RGB_BACKEND=channels\nARMADA_RGB_TARGETS=red=l:r1\\ green=l:g1\nARMADA_RGB_CORRECTION=red:0\\,20\\,20\n",
        )
        .unwrap();
        assert_eq!(values["ARMADA_RGB_BACKEND"], "channels");
        assert_eq!(values["ARMADA_RGB_TARGETS"], "red=l:r1 green=l:g1");
        assert_eq!(values["ARMADA_RGB_CORRECTION"], "red:0,20,20");
    }
}
