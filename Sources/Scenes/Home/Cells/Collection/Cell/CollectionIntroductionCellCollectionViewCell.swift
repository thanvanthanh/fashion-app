//
//  CollectionIntroductionCellCollectionViewCell.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import UIKit

class CollectionIntroductionCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var collectionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(image: String) {
        collectionImage.image = UIImage(named: image)
    }

}
