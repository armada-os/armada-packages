use crate::ColorCorrection;
use anyhow::{bail, Result};
use serde::{Deserialize, Serialize};

const CONFIG_VERSION: u32 = 1;

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct LightingConfig {
    pub version: u32,
    pub enabled: bool,
    pub brightness: u8,
    pub color: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub correction: Option<ColorCorrection>,
}

impl Default for LightingConfig {
    fn default() -> Self {
        Self {
            version: CONFIG_VERSION,
            enabled: false,
            brightness: 25,
            color: "FFFFFF".into(),
            correction: None,
        }
    }
}

impl LightingConfig {
    pub fn validate(mut self) -> Result<Self> {
        if self.version != CONFIG_VERSION {
            bail!("unsupported config version {}", self.version);
        }
        if self.brightness > 100 {
            bail!("brightness must be between 0 and 100");
        }
        if self.color.len() != 6 || !self.color.bytes().all(|c| c.is_ascii_hexdigit()) {
            bail!("color must be six hexadecimal RGB digits");
        }
        if let Some(correction) = &self.correction {
            correction.validate()?;
        }

        self.color.make_ascii_uppercase();
        Ok(self)
    }

    pub(crate) fn rgb(&self) -> [u8; 3] {
        let red: u8 = u8::from_str_radix(&self.color[0..2], 16).expect("validated color");
        let green: u8 = u8::from_str_radix(&self.color[2..4], 16).expect("validated color");
        let blue: u8 = u8::from_str_radix(&self.color[4..6], 16).expect("validated color");
        [red, green, blue]
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn validates_and_normalizes_config() {
        let old_config: LightingConfig = serde_json::from_str(
            r#"{"version":1,"enabled":true,"brightness":25,"color":"FFFFFF"}"#,
        )
        .unwrap();
        assert!(old_config.correction.is_none());

        let config: LightingConfig = LightingConfig {
            color: "a1b2c3".into(),
            ..LightingConfig::default()
        }
        .validate()
        .unwrap();
        assert_eq!(config.color, "A1B2C3");

        for color in ["fff", "GG0000", "0000000"] {
            let config: LightingConfig = LightingConfig {
                color: color.into(),
                ..LightingConfig::default()
            };
            assert!(config.validate().is_err());
        }

        let brightness: LightingConfig = LightingConfig {
            brightness: 101,
            ..LightingConfig::default()
        };
        assert!(brightness.validate().is_err());

        let version: LightingConfig = LightingConfig {
            version: 2,
            ..LightingConfig::default()
        };
        assert!(version.validate().is_err());
    }
}
