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

    DispatchQueue.main.async {
      var config = PHPickerConfiguration()
      config.selectionLimit = limit
      config.filter = .images
      config.preferredAssetRepresentationMode = .current
      config.selection = .ordered
      config.preselectedAssetIdentifiers = []

      let picker = PHPickerViewController(configuration: config)
      picker.delegate = self
      viewController.present(picker, animated: true, completion: nil)
    }
  }

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    DispatchQueue.main.async {
      picker.dismiss(animated: true, completion: nil)
      if results.isEmpty {
        self.pickerCompletion?([])
        self.pickerCompletion = nil
        return
      }

      var images: [UIImage] = []
      let group = DispatchGroup()
      for result in results {
        group.enter()
        result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
          defer { group.leave() }
          if let image = object as? UIImage {
            images.append(image)
          }
        }
      }

      group.notify(queue: .main) { [weak self] in
        self?.pickerCompletion?(images)
        self?.pickerCompletion = nil
      }
    }
  }

  @objc public func selectPhotos(_ invoke: Invoke) {
    DispatchQueue.main.async {
      guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
        invoke.reject("Unable to find root view controller.")
        return
      }

      do {
        let args = try invoke.parseArgs(CommandArgs.self)
        let selectionLimit = args.selectionLimit ?? 0

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
}

@_cdecl("init_plugin_photos")
func initPlugin() -> Plugin {
  return PhotosPlugin()
}
