//
//  NewArrivalHomeModel.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import Foundation

struct NewArrivalHomeModel: Decodable, Identifiable {
    let id: Int
    var image: String
    var name: String
    var price: String
    var type: String
}
