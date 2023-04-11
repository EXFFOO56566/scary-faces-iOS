//
//  PreviewCollectionViewCell.swift
//  ScaryFace
//
//  Created by Apps4World on 9/12/20.
//  Copyright © 2020 Apps4World. All rights reserved.
//

import UIKit

/// Shows a preview of the asset. Ex.: abs, lips, tattoo
class PreviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var assetImageView: UIImageView!
    
    func configure(asset: String) {
        assetImageView.image = UIImage(named: asset)
    }
    
    func setSelected(_ selected: Bool) {
        contentView.alpha = selected ? 1.0 : 0.3
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = selected ? 2 : 0.0
        contentView.layer.borderColor = UIColor.darkGray.cgColor
    }
}
