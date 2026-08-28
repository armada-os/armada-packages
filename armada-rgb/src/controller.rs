use crate::{config, runtime, LightingBackend, LightingConfig};
use anyhow::Result;
use std::path::PathBuf;

pub struct Controller {
    config_path: PathBuf,
    backend: LightingBackend,
}

impl Controller {
    pub fn new(config_path: PathBuf, backend: LightingBackend) -> Self {
        Self {
            config_path,
            backend,
        }
    }

    pub fn from_env() -> Self {
        let (config_path, backend): (PathBuf, LightingBackend) = runtime::from_env();
        Self::new(config_path, backend)
    }

    pub fn get(&self) -> Result<LightingConfig> {
        let mut config: LightingConfig = config::load(&self.config_path)?;
        if config.correction.is_none() {
            config.correction = self.backend.default_correction();
        }
        Ok(config)
    }

    pub fn set(&self, config: LightingConfig) -> Result<LightingConfig> {
        let mut config: LightingConfig = config.validate()?;
        if config.correction.is_none() {
            config.correction = self.backend.default_correction();
        }
        self.backend.apply(&config)?;
        config::save(&self.config_path, &config)?;
        Ok(config)
    }

    pub fn off(&self) -> Result<LightingConfig> {
        let mut config: LightingConfig = self.get()?;
        config.enabled = false;
        self.set(config)
    }

    pub fn apply(&self) -> Result<Option<String>> {
        if let Some(reason) = self.backend.unsupported_reason() {
            return Ok(Some(reason.into()));
        }

        let config: LightingConfig = self.get()?;
        self.backend.apply(&config)?;
        Ok(None)
    }
}
