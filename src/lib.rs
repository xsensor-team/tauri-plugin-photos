use tauri::{
  plugin::{Builder, TauriPlugin},
  Manager, Runtime,
};

use std::{collections::HashMap, sync::Mutex};

pub use models::*;

#[cfg(desktop)]
mod desktop;
#[cfg(mobile)]
mod mobile;

mod commands;
mod error;
mod models;

pub use error::{Error, Result};

#[cfg(desktop)]
use desktop::Photos;
#[cfg(mobile)]
use mobile::Photos;

#[derive(Default)]
struct MyState(Mutex<HashMap<String, String>>);

/// Extensions to [`tauri::App`], [`tauri::AppHandle`] and [`tauri::Window`] to access the photos APIs.
pub trait PhotosExt<R: Runtime> {
  fn photos(&self) -> &Photos<R>;
}

impl<R: Runtime, T: Manager<R>> crate::PhotosExt<R> for T {
  fn photos(&self) -> &Photos<R> {
    self.state::<Photos<R>>().inner()
  }
}

/// Initializes the plugin.
pub fn init<R: Runtime>() -> TauriPlugin<R> {
  Builder::new("photos")
    .invoke_handler(tauri::generate_handler![commands::execute])
    .setup(|app, api| {
      #[cfg(mobile)]
      let photos = mobile::init(app, api)?;
      #[cfg(desktop)]
      let photos = desktop::init(app, api)?;
      app.manage(photos);

      // manage state so it is accessible by the commands
      app.manage(MyState::default());
      Ok(())
    })
    .build()
}
