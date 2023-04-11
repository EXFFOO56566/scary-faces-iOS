//
//  AppImagePickerController.swift
//  ScaryFace
//
//  Created by Apps4World on 9/12/20.
//  Copyright © 2020 Apps4World. All rights reserved.
//

import UIKit

// Protocol to notify the controller when an image was taken/selected
public protocol AppImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

// Image Picker Manager - class to handle launching/handling of image picker
open class AppImagePickerController: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: AppImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: AppImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    public func presentPhotoLibrary() {
        pickerController.sourceType = .savedPhotosAlbum
        presentationController?.present(self.pickerController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}

// Implement image picker controller delegate
extension AppImagePickerController: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return self.pickerController(picker, didSelect: nil) }
        self.pickerController(picker, didSelect: image)
    }
}

// Implement image picker navigation delegate
extension AppImagePickerController: UINavigationControllerDelegate { }

