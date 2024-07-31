//
//  NetworkIndicatorPlugin.swift
//  Base-ios
//
//  Created by Than Van Thanh on 31/7/24.
//

import Foundation
import Moya

enum NetworkIndicatorPlugin {
    
    static func indicatorPlugin() -> NetworkActivityPlugin {
        return NetworkActivityPlugin(networkActivityClosure: { (change, _) in
            DispatchQueue.main.async {
                switch change {
                case .began:
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                case .ended:
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        })
    }
    
}
