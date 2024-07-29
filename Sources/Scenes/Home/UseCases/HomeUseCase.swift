//
//  HomeUseCase.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import Foundation
import Combine

protocol HomeServiceProtocol: AnyObject {
    func getData() -> AnyPublisher<[HomeModel], APIError>
}

class HomeRequest: HomeServiceProtocol {
    func getData() -> AnyPublisher<[HomeModel], APIError> {
        loadJson()
    }
    
    func loadJson() -> AnyPublisher<[HomeModel], APIError> {
        guard let url = Bundle.main.url(forResource: "home", withExtension: "json") else {
            return Fail(error: APIError.noData).eraseToAnyPublisher()
        }
        
        return Future<[HomeModel], APIError> { promise in
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let homeModel = try decoder.decode([HomeModel].self, from: data)
                promise(.success(homeModel))
            } catch {
                promise(.failure(APIError.noData))
            }
        }
        .eraseToAnyPublisher()
    }
}
