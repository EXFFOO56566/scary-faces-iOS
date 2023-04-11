//
//  EditorViewController.swift
//  ScaryFace
//
//  Created by Apps4World on 9/12/20.
//  Copyright © 2020 Apps4World. All rights reserved.
//

import UIKit
import Apps4World
import GoogleMobileAds

/// Editor for the app
class EditorViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var scrollView: UIScrollView!
    private var imageView: UIImageView!
    private var assets: [String] = [String]()
    private var selectedAsset: Int?
    private var assetImageView: CustomImageView?
    private var interstitial: GADInterstitial!
    private var selectedAssetCount: Int = 0
    var image: UIImage! = UIImage(named: "man_model")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareInterstitialAd()
        setupScrollView()
        setupAssets()
    }

    /// Prepare the AdMob interstitial and load the ad request
    private func prepareInterstitialAd() {
        interstitial = GADInterstitial(adUnitID: AppConfig.adMobAdID)
        let request = GADRequest()
        interstitial.load(request)
    }
    
    /// Show Interstitial ads when ready
    private func showInterstitialAds() {
        if interstitial.isReady && selectedAssetCount % AppConfig.adsInterval == 0 {
            interstitial.present(fromRootViewController: self)
            prepareInterstitialAd()
        }
    }
    
    private func setupScrollView() {
        imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
        
        let zoomScale = min(scrollView.bounds.size.width / image.size.width, scrollView.bounds.size.height / image.size.height)
        
        let scaleX = scrollView.frame.size.width / image.size.width
        let scaleY = scrollView.frame.size.height / image.size.height
        let defaultZoomScale = scaleX < scaleY ? scaleY : scaleX
        
        scrollView.minimumZoomScale = zoomScale
        scrollView.maximumZoomScale = 10
        scrollView.zoomScale = defaultZoomScale
    }
    
    private func setupAssets() {
        for index in 0..<INT_MAX {
            let assetName = "face\(index)"
            if UIImage(named: assetName) != nil { assets.append(assetName) } else { break }
        }
    }
    
    private func applySelectedAssetFilter() {
        guard let selectedImage = UIImage(named: assets[selectedAsset ?? 0]) else {
            return
        }
        if assetImageView == nil {
            assetImageView = CustomImageView(image: selectedImage)
            assetImageView?.frame = CGRect(x: image.size.width/2 - selectedImage.size.width/2, y: image.size.height/2 - selectedImage.size.height/2, width: selectedImage.size.width, height: selectedImage.size.height)
            assetImageView?.previousLocation = assetImageView!.frame.origin
            assetImageView?.didSelectImageView = {
                self.scrollView.panGestureRecognizer.isEnabled = false
                self.scrollView.isScrollEnabled = false
                self.imageView.alpha = 0.5
            }
            imageView.addSubview(assetImageView!)
        } else {
            assetImageView?.image = selectedImage
            assetImageView?.sizeToFit()
        }
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enablePanGestureScrollView(_ sender: Any) {
        scrollView.panGestureRecognizer.isEnabled = true
        scrollView.isScrollEnabled = true
        imageView.alpha = 1.0
    }
    
    @IBAction func saveBeautifyImage(_ sender: Any) {
        ScaryFacesManager.saveImage(image, assset: assetImageView, controller: self,
                                    selector: #selector(image(_:didFinishSavingWithError:contextInfo:)))
    }
    
    @IBAction func changeAssetAlpha(_ sender: UISlider) {
        assetImageView?.alpha = CGFloat(sender.value)
    }
}

// MARK: - Handle image zoom in/out
extension EditorViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.isScrollEnabled && scrollView.panGestureRecognizer.isEnabled ? imageView : nil
    }
}

// MARK: - Handle assets collection
extension EditorViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PreviewCollectionViewCell {
            cell.configure(asset: assets[indexPath.row])
            cell.setSelected(indexPath.row == selectedAsset)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.height
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAsset = indexPath.row
        selectedAssetCount += 1
        collectionView.visibleCells.forEach({ ($0 as? PreviewCollectionViewCell)?.setSelected(false) })
        (collectionView.cellForItem(at: indexPath) as? PreviewCollectionViewCell)?.setSelected(true)
        applySelectedAssetFilter()
        showInterstitialAds()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Great Job!", message: "Your Scary Face image has been saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
