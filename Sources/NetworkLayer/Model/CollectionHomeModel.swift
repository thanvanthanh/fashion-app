//
//  CollectionHomeModel.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import Foundation

struct CollectionHomeModel: Decodable, Identifiable {
    let id: Int
    let listCollection: [String]
}
