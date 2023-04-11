//
//  IntroViewController.swift
//  ScaryFace
//
//  Created by Apps4World on 9/12/20.
//  Copyright © 2020 Apps4World. All rights reserved.
//

import UIKit

// Main dashboard of the app
class IntroViewController: UIViewController, AppImagePickerDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var scaryFaceOverlayImageView: UIImageView!
    private var imagePicker: AppImagePickerController!
    private var assets: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAssets()
        animateScrollView()
        animateScaryFace()
        imagePicker = AppImagePickerController(presentationController: self, delegate: self)
    }

    private func setupAssets() {
        for index in 0..<INT_MAX {
            let assetName = "face\(index)"
            if UIImage(named: assetName) != nil { assets.append(assetName) } else { break }
        }
    }
    
    private func animateScrollView() {
        UIView.animate(withDuration: 5, delay: 1, animations: {
            let indexPath = IndexPath(item: self.assets.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: false)
        })
    }
    
    private func animateScaryFace() {
        UIView.animate(withDuration: 2.5, delay: 4, animations: {
            self.scaryFaceOverlayImageView.alpha = 1.0
        })
    }
    
    func didSelect(image: UIImage?) {
        if let selectedImage = image, let editor = storyboard?.instantiateViewController(withIdentifier: "editor") as? EditorViewController {
            editor.image = selectedImage
            present(editor, animated: true, completion: nil)
        }
    }
    
    @IBAction func chooseExistingModel(_ sender: Any) {
        let alert = UIAlertController(title: "Choose a model", message: "Would you like to choose an existing template/model?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Man", style: .default, handler: { (_) in
            self.didSelect(image: UIImage(named: "man_model"))
        }))
        alert.addAction(UIAlertAction(title: "Woman", style: .default, handler: { (_) in
            self.didSelect(image: UIImage(named: "woman_model"))
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func chooseLibraryImage(_ sender: Any) {
        imagePicker.presentPhotoLibrary()
    }
}

// MARK: - Handle assets collection
extension IntroViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PreviewCollectionViewCell {
            cell.configure(asset: assets[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.height
        return CGSize(width: size, height: size)
    }
}
