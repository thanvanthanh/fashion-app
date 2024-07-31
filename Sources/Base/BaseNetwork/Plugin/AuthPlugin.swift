//
//  AuthPlugin.swift
//  Base-ios
//
//  Created by Than Van Thanh on 31/7/24.
//

import Foundation
import Moya

struct AuthPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        // add Ocp-Apim-Subscription-Key
        // TODO: -
        // request.addValue("SubscriptionKey", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        return request
    }
    
}
