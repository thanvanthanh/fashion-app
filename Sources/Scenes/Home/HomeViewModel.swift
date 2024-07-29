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

extension HomeViewModel: ViewModelType {
    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
        
    }
    
    final class Output: ObservableObject {
        @Published var response: [HomeModel] = []
        @Published var isLoading = false
        @Published var error: Error?
    }
    
    func transform(_ input: Input, _ disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.loadTrigger
            .flatMap {
                self.getHomeData
                    .getData()
                    .trackError(self.errorIndicator)
                    .trackActivity(self.activityIndicator)
                    .eraseToAnyPublisher()
                
            }
            .assign(to: \.response, on: output)
            .store(in: disposeBag)
        
        
        return output
    }
}
