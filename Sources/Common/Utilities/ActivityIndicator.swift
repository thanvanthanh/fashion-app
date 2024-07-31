//
//  ActivityIndicator.swift
//  Base-ios
//
//  Created by Than Van Thanh on 31/7/24.
//

import RxSwift
import RxCocoa

private struct ActivityToken<E>: ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}

public class ActivityIndicator: SharedSequenceConvertibleType {
    
    public typealias SharingStrategy = DriverSharingStrategy
    
    public typealias Element = Bool
    
    private let _lock = NSRecursiveLock()
    private let _relay = BehaviorRelay(value: 0)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    @Atomic private var isShowedLoading = false
    
    public init() {
        _loading = _relay.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<Source: ObservableConvertibleType>(_ source: Source) -> Observable<Source.Element> {
        return Observable.using({ () -> ActivityToken<Source.Element> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }, observableFactory: { value in
            return value.asObservable()
        })
    }
    
    
    fileprivate func trackActivityOfObservableOnlyOnce<Source: ObservableConvertibleType>(_ source: Source) -> Observable<Source.Element> {
        return Observable.using({ () -> ActivityToken<Source.Element> in
            if !self.isShowedLoading {
                self.increment()
            }
            let action = self.isShowedLoading ? self.noneAction : self.decrement
            self.isShowedLoading = true
            return ActivityToken(source: source.asObservable(), disposeAction: action)
        }, observableFactory: { value in
            return value.asObservable()
        })
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
    
    private func increment() {
        _lock.lock()
        _relay.accept(_relay.value + 1)
        _lock.unlock()
    }
    
    private func decrement() {
        _lock.lock()
        _relay.accept(_relay.value - 1)
        _lock.unlock()
    }
    
    func noneAction() {}
    
}

extension ObservableConvertibleType {
    public func trackActivity(
        _ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
    public func trackActivityOnlyOnce(
        _ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservableOnlyOnce(self)
    }
}
