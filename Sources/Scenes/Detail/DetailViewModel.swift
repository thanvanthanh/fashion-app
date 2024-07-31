//
//  DetailViewModel.swift
//  mvvm-combine-uikit
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import Foundation
import Combine

class DetailViewModel: BaseViewModel {
    let useCase: RepositoryDetailUseCase
    let repo: SearchModel
    
    init(useCase: RepositoryDetailUseCase = RepositoryDetailUseCase(),
         repo: SearchModel) {
        self.useCase = useCase
        self.repo = repo
    }
}
