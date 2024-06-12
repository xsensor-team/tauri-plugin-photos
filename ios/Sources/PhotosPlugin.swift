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

  func requestAccess(completion: @escaping (Bool) -> Void) {
    PHPhotoLibrary.requestAuthorization { status in
      DispatchQueue.main.async {
        completion(status == .authorized)
      }
    }
  }

  func presentImagePicker(
    from viewController: UIViewController, selectionLimit limit: Int,
    completion: @escaping ([UIImage]?) -> Void
  ) {
    self.pickerCompletion = completion  // Set the new completion handler

    var config = PHPickerConfiguration(photoLibrary: .shared())
    config.selectionLimit = limit  // No limit on selections
    config.filter = .images  // Only images can be picked

    let picker = PHPickerViewController(configuration: config)
    picker.delegate = self
    viewController.present(picker, animated: true, completion: nil)
  }

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true, completion: nil)

    var images: [UIImage] = []
    let group = DispatchGroup()

    for result in results {
      group.enter()
      result.itemProvider.loadObject(ofClass: UIImage.self) { [] (object, error) in
        defer { group.leave() }
        if let image = object as? UIImage {
          images.append(image)
        }
      }
    }

    group.notify(queue: .main) { [weak self] in
      self?.pickerCompletion?(images)  // Use the current completion handler
      self?.pickerCompletion = nil  // Clear the completion handler after use
    }
  }

  @objc public func selectPhotos(_ invoke: Invoke) {
    guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
      invoke.reject("Unable to find root view controller.")
      return
    }

    do {
      let args = try invoke.parseArgs(CommandArgs.self)
      let selectionLimit = args.selectionLimit ?? 0

      requestAccess { [weak self] authorized in
        if authorized {
          self?.presentImagePicker(
            from: rootViewController, selectionLimit: Int(selectionLimit)
          ) { images in
            if let images = images {
              let imageData = images.compactMap { $0.pngData() }
              invoke.resolve(imageData)
            } else {
              invoke.reject("No images were selected.")
            }
          }
        } else {
          invoke.reject("Photo library access was denied.")
        }
      }
    } catch {
      invoke.reject("Invalid arguments.")
      return
    }
  }

}

@_cdecl("init_plugin_photos")
func initPlugin() -> Plugin {
  return PhotosPlugin()
}
