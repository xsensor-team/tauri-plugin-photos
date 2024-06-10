import { invoke } from "@tauri-apps/api/core"

export async function execute() {
  await invoke("plugin:photos|execute")
}

export async function selectPhotos() {
  return await invoke("plugin:photos|selectPhotos")
}
