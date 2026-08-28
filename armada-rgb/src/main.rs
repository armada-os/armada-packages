//! Command line interface for RGB lighting.

use anyhow::Result;
use armada_rgb::{ColorCorrection, Controller, LightingConfig};
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(version, about)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Show the saved lighting configuration.
    Get,
    /// Set a solid color and brightness.
    Set {
        #[arg(long)]
        color: String,
        #[arg(long)]
        brightness: u8,
        /// RGB correction trigger and channel reductions.
        #[arg(long, value_name = "TRIGGER:RED,GREEN,BLUE")]
        correction: Option<ColorCorrection>,
    },
    /// Turn the stick lights off and save that state.
    Off,
    /// Apply the saved configuration.
    Apply,
}

fn main() -> Result<()> {
    let cli: Cli = Cli::parse();
    let controller: Controller = Controller::from_env();

    match cli.command {
        Command::Get => {
            let config: LightingConfig = controller.get()?;
            println!("{}", serde_json::to_string_pretty(&config)?);
        }
        Command::Set {
            color,
            brightness,
            correction,
        } => {
            let mut config: LightingConfig = controller.get()?;
            config.enabled = true;
            config.color = color;
            config.brightness = brightness;
            if let Some(correction) = correction {
                config.correction = Some(correction);
            }
            let config: LightingConfig = controller.set(config)?;
            println!("{}", serde_json::to_string_pretty(&config)?);
        }
        Command::Off => {
            let config: LightingConfig = controller.off()?;
            println!("{}", serde_json::to_string_pretty(&config)?);
        }
        Command::Apply => {
            if let Some(reason) = controller.apply()? {
                eprintln!("RGB unsupported: {reason}");
            }
        }
    }
    Ok(())
}
