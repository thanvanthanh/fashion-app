//
//  HomeModel.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import Foundation

struct HomeModel: Decodable, Identifiable {
    var id: Int
    var collection: CollectionHomeModel
    var newArrival: NewArrivalHomeModel
}

extension HomeModel: Hashable {
    static func == (lhs: HomeModel, rhs: HomeModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
