//
//  HomeViewModel.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    let getHomeData: HomeServiceProtocol
    
    init(getHomeData: HomeServiceProtocol) {
        self.getHomeData = getHomeData
    }
}

