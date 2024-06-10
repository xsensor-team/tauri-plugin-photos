# Tauri Plugin Photos

## Install

add directly to your package.json

```json
"tauri-plugin-photos-api": "github:xsensor-team/tauri-plugin-photos#main"
```

and to your cargo.toml

```toml
tauri-plugin-photos = { git = "https://github.com/xsensor-team/tauri-plugin-photos.git" }
```

and connect the plugin in your tauri builder

```rust
tauri::Builder::default()
    .setup()
    .plugin(tauri_plugin_photos::init())
    .invoke_handler(tauri::generate_handler![])
    .run(tauri::generate_context!())
    .expect("Error while building tauri application");
```

### iOS instructions

make sure to add the following permission to your `info.plist`

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Need access to select photos</string>
```

### Android instructions

TBD

## Usage

See the [examples](https://github.com/xsensor-team/tauri-plugin-photos/tree/main/examples/tauri-app) for more information

```javascript
import { selectPhotos } from 'tauri-plugin-photos-api'

 ...

const photos = await selectPhotos() // photos will be an array of base64 encoded images

 ...

<img src={`data:image/png;base64,${photos[0]}`} />
```
