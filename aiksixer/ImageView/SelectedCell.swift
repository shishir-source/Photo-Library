//
//  SelectedCell.swift
//  aiksixer
//
//  Created by Shishir Ahmed on 8/8/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import UIKit

class SelectedCell: UICollectionViewCell {
    
    //MARK:: Properties

    static let identfier = "SelectedCell"
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:: Functions
    
    public func configure(image: UIImage?) {
        if let img = image {
            selectedImage.image = img
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "SelectedCell", bundle: nil)
    }

}
