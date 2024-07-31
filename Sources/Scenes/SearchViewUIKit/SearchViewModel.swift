//
//  SearchViewModel.swift
//  base-combine
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import RxSwift
import Foundation
import RxCocoa

final class SearchViewModel: BaseViewModel {
    
    private let repo: SearchRequest
    
    init(repo: SearchRequest) {
        self.repo = repo
    }
}

extension SearchViewModel: ViewModelType {
    
    struct Input {
        let trigger: Driver<String>
        let searchTrigger: Driver<String>
    }
    
    struct Output {
        let searchResponse: Driver<[SearchModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let searchResponse = input.searchTrigger
            .flatMapLatest { [weak self] searchText -> Driver<[SearchModel]> in
                guard let self else { return .empty() }
                return self.repo.search(username: searchText)
                    .map( { $0.items ?? [] })
                    .trackActivity(self.loading)
                    .asDriverOnErrorJustComplete()
            }
        
        return Output(searchResponse: searchResponse)
    }
}

