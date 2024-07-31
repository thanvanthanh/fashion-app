//
//  BaseViewModel.swift
//  base-combine
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import Moya

class BaseViewModel: NSObject {
    
    let error = ErrorTracker()
    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isHeaderLoading = BehaviorRelay<Bool>(value: false)
    let isFooterLoading = BehaviorRelay<Bool>(value: false)
    
        
    override init() {
        super.init()
        
        error
            .asObservable()
            .subscribe(onNext: { error in
                if let error = error as? AppError {
                    print(error.localizedDescription)
                } else if let error = error as? RxError {
                    switch error {
                    case .timeout:
                        AppHelper.showMessage(message: MessageHelper.serverError.timeOut)
                    default: return
                    }
                } else if let error = error as? MoyaError {
                    switch error {
                    case .objectMapping(_, let response), .jsonMapping(let response), .statusCode(let response):
                        print(response)
                    default:
                        return
                    }
                } else {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
}

