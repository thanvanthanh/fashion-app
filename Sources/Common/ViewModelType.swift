//
//  ViewModelType.swift
//  Base-ios
//
//  Created by Than Van Thanh on 31/7/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
