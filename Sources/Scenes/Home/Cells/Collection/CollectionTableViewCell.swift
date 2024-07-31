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
        let nextIndex = (currentIndex + 1) % listImage.count
        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func config(image: [String]) {
        listImage = [image.last ?? ""] + image + [image.first ?? ""]
        pageControl.setNumberOfPage(image.count)
        collectionView.reloadData()
        DispatchQueue.main.async {
            let initialIndex = 1
            self.currentIndex = initialIndex
            self.collectionView.scrollToItem(at: IndexPath(item: initialIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func exploreAction(_ sender: UIButton) {
    }
    
}

extension CollectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let actualIndex = indexPath.item % listImage.count
        let cell = collectionView.dequeueReusableCell(cell: CollectionIntroductionCellCollectionViewCell.self,
                                                      indexPath: indexPath)
        cell.config(image: listImage[actualIndex])
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentIndex()
        adjustScrollPositionIfNeeded()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentIndex()
        adjustScrollPositionIfNeeded()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startTimer()
    }
    
    private func updateCurrentIndex() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
                currentIndex = visibleIndexPath.item
                
                // Adjust actual index calculation
                let actualIndex: Int
                if currentIndex == 0 {
                    actualIndex = listImage.count - 3 // Last actual item
                } else if currentIndex == listImage.count - 1 {
                    actualIndex = 0 // First actual item
                } else {
                    actualIndex = currentIndex - 1
                }
                
                pageControl.setCurrentPage(actualIndex)
            }
    }
    
    private func adjustScrollPositionIfNeeded() {
        if currentIndex == 0 {
            collectionView.scrollToItem(at: IndexPath(item: listImage.count - 2, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = listImage.count - 2
        } else if currentIndex == listImage.count - 1 {
            collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = 1
        }
    }
}
