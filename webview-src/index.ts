import { invoke } from "@tauri-apps/api/core"

export async function execute() {
  await invoke("plugin:photos|execute")
}

export async function selectPhotos(selectionLimit: number = 1) {
  return await invoke("plugin:photos|selectPhotos", { selectionLimit })
}
