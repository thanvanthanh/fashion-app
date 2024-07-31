//
//  FilterCollectionViewCell.swift
//  Base-ios
//
//  Created by Than Van Thanh on 30/7/24.
//

import UIKit

final class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var filterTitle: UILabel!
    @IBOutlet private weak var selectedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(title: String) {
        filterTitle.text = title
    }

}
