//
//  ApiConnection.swift
//  Base-ios
//
//  Created by Than Van Thanh on 31/7/24.
//

import Foundation
import RxSwift
import Moya

final class ApiConnection {
    
    static let shared = ApiConnection()
    
    private let apiProvider: ApiProvider<MultiTarget>
    
    private init() {
        apiProvider = ApiProvider(plugins: [AuthPlugin()])
    }
}

extension ApiConnection {
    func request<T: Codable>(target: MultiTarget, type: T.Type) -> Single<T> {
        return apiProvider.request(target: target).map(T.self)
    }
    
    /*
    func requestArray<T: Codable>(target: MultiTarget, type: T.Type) -> Single<[T]> {
        return apiProvider.request(target: target).map([T].self)
    }
    */
    
    func request(target: MultiTarget) -> Single<Int> {
        return apiProvider.request(target: target)
    }
    
    func request(target: MultiTarget) -> Single<String> {
        return apiProvider.request(target: target)
    }
}
