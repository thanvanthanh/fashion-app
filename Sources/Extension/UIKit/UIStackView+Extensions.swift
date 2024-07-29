//
//  UIStackView+Extensions.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import UIKit

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
    func spacer(color: UIColor = .clear, height: CGFloat = 1) {
        let view = UIView()
        view.backgroundColor = color
        self.addArrangedSubview(view)
    }
}
