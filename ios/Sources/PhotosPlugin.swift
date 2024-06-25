import Photos
import PhotosUI
import SwiftRs
import Tauri
import UIKit
import WebKit

class CommandArgs: Decodable {
  var selectionLimit: Int?
}

class PhotosPlugin: Plugin, PHPickerViewControllerDelegate {
  private var pickerCompletion: (([UIImage]?) -> Void)?

  func presentImagePicker(
    from viewController: UIViewController,
    selectionLimit limit: Int,
    completion: @escaping ([UIImage]?) -> Void
  ) {
    self.pickerCompletion = completion

    var config = PHPickerConfiguration(photoLibrary: .shared())
    config.selectionLimit = limit
    config.filter = .images
    config.preferredAssetRepresentationMode = .current
    config.selection = .ordered
    config.preselectedAssetIdentifiers = []

    // Set the mode to .limited to ensure only limited library access
    config.accessMode = .limited

    let picker = PHPickerViewController(configuration: config)
    picker.delegate = self
    viewController.present(picker, animated: true, completion: nil)
  }

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    // The rest of this function remains unchanged
    // ...
  }

  @objc public func selectPhotos(_ invoke: Invoke) {
    guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
      invoke.reject("Unable to find root view controller.")
      return
    }

    do {
      let args = try invoke.parseArgs(CommandArgs.self)
      let selectionLimit = args.selectionLimit ?? 0

      // We don't need to request access explicitly anymore
      // The PHPickerViewController will handle it for us
      self.presentImagePicker(
        from: rootViewController,
        selectionLimit: selectionLimit
      ) { images in
        if let images = images {
          let imageData = images.compactMap { $0.pngData() }
          invoke.resolve(imageData)
        } else {
          invoke.reject("No images were selected.")
        }
      }
    } catch {
      invoke.reject("Invalid arguments.")
    }
  }
}

@_cdecl("init_plugin_photos")
func initPlugin() -> Plugin {
  return PhotosPlugin()
}
