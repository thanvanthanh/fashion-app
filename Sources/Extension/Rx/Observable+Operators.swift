//
//  Observable+Operators.swift
//  Base-ios
//
//  Created by Than Van Thanh on 31/7/24.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    func catchErrorJustComplete() -> Observable<Element> {
        return `catch` { _ in
            return Observable.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func unwrap<Result>() -> Observable<Result> where Element == Result? {
        return self.compactMap { $0 }
    }
    
}

extension ObservableType where Element == Bool {
    
    func not() -> Observable<Bool> {
        return self.map(!)
    }
    
}
