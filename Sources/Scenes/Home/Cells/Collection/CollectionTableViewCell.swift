//
//  CollectionTableViewCell.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var exploreView: UIView!
    @IBOutlet private weak var pageControl: PageControlView!
    
    private var listImage: [String] = []
    private var currentIndex = 0
    private var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        exploreView.clipsToBounds = true
        exploreView.layer.cornerRadius = 20
        setupCollectionView()
        startTimer()
    }
    
    private func setupCollectionView() {
        collectionView.register(cell: CollectionIntroductionCellCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil, repeats: true)
    }
    
    @objc
    func timerAction() {
        let desiredScrollPosition = (currentIndex < listImage.count - 1) ? currentIndex + 1 : 0
        collectionView.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
        pageControl.setCurrentPage(currentIndex)
    }
    
    func config(image: [String]) {
        listImage = image
        pageControl.setNumberOfPage(listImage.count)
        collectionView.reloadData()
    }
    
    
    
    @IBAction func exploreAction(_ sender: UIButton) {
    }
    
}

extension CollectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cell: CollectionIntroductionCellCollectionViewCell.self,
                                                      indexPath: indexPath)
        cell.config(image: listImage[indexPath.row])
        return cell
    }
}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
