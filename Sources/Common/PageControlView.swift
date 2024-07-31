//
//  PageControlView.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import UIKit

final class PageControlView: UIView {
    
    private var numberOfPages: Int = 0
    private var currentPage: Int = 0
    
    private let space: CGFloat = 4
    private let dotWidth: CGFloat = 10
    private let dotHeight: CGFloat = 10
    private let selectedWidth: CGFloat = 20
    private let mainStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setNumberOfPage(_ pages: Int) {
        guard self.numberOfPages != pages else { return }
        self.numberOfPages = pages
        guard numberOfPages > currentPage else { return }
        self.updateNumberOfPage()
    }
    
    func setCurrentPage(_ page: Int) {
        guard page < self.numberOfPages else {
            return
        }
        self.updateCurrentPage(page)
    }
    
    private func initView() {
        mainStackView.spacing = space
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fill
        self.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.heightAnchor.constraint(equalToConstant: dotHeight),
            mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func updateNumberOfPage() {
        mainStackView.removeFullyAllArrangedSubviews()
        for i in 0 ..< self.numberOfPages {
            let dot = UIImageView()
            
            dot.image = i == currentPage
            ? UIImage(asset: Asset.AssetsIOS.iconRectangleCurrent)
            : UIImage(asset: Asset.AssetsIOS.iconRectangle)
            
            dot.backgroundColor = .clear
            mainStackView.addArrangedSubview(dot)
            dot.translatesAutoresizingMaskIntoConstraints = false
            
            dot.widthAnchor.constraint(equalToConstant: dotWidth).isActive = true
        }
    }
    
    private func updateCurrentPage(_ page: Int) {
        guard page != currentPage else { return }
        currentPage = page
        updateNumberOfPage()
    }
}
