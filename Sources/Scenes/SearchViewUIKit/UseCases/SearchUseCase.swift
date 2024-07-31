//
//  SearchUseCase.swift
//  base-combine
//
//  Created by Thân Văn Thanh on 29/08/2023.
//

import Foundation
import RxSwift
import Moya

protocol SearchServiceProtocol {
    func search(username: String) -> Single<ItemSearchResponse>
}

class SearchRequest: SearchServiceProtocol {
    func search(username: String) -> Single<ItemSearchResponse> {
        return ApiConnection.shared.request(
            target: MultiTarget(APIRouter.search(username: username)),
            type: ItemSearchResponse.self)
    }
}
