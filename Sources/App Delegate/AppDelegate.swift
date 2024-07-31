//
//  AppDelegate.swift
//  mvvm-combine-uikit
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import UIKit
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return true }
        SearchViewCoordinator.shared.start(data: window)
        
        //AFNetworking.shared.listenForReachability()
        
        // Leak Detector
         configLeakDetector()
        return true
    }
    
    private func configLeakDetector() {
        LeakDetector.instance.status
            .subscribe(
                onNext: { status in
                    print("LeakDetectorRxSwift \(status)")
                }
            )
            .disposed(by: rx.disposeBag)
        
        LeakDetector.instance.isLeaked
            .subscribe(
                onNext: { message in
                    if let message = message {
                        print("LEAK \(message)")
                    }
                }
            )
            .disposed(by: rx.disposeBag)
    }

}
