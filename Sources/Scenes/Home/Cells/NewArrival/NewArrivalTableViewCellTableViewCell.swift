//
//  NewArrivalTableViewCellTableViewCell.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import UIKit

class NewArrivalTableViewCellTableViewCell: UITableViewCell {

    @IBOutlet private weak var filterCollectionView: UICollectionView!
    
    @IBOutlet private weak var productCollectionView: UICollectionView!
    
    var arrayFilter: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupFilterCollectionView()
    }
    
    func configCell(arrFilter: [String]) {
        arrayFilter = arrFilter
    }
    
    private func setupFilterCollectionView() {
        filterCollectionView.register(cell: FilterCollectionViewCell.self)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: filterCollectionView.bounds.width / 6,
                                 height: filterCollectionView.bounds.height)
        
        layout.minimumInteritemSpacing = 26
        layout.minimumLineSpacing = 0
        filterCollectionView.collectionViewLayout = layout
        
        filterCollectionView.dataSource = self
    }
}

extension NewArrivalTableViewCellTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cell: FilterCollectionViewCell.self, indexPath: indexPath)
        cell.config(title: arrayFilter[indexPath.row])
        return cell
    }
    
}
