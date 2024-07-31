//
//  AppHelper.swift
//  Base-ios
//
//  Created by Than Van Thanh on 31/7/24.
//

import Foundation
import RxSwift

final class AppHelper {
        
    private init() {}
    
    class func convert<T: Codable>(_ object: T) -> String {
        guard let data = try? JSONEncoder().encode(object) else { return "" }
        guard let jsonString = String(data: data, encoding: .utf8) else { return "" }
        return jsonString
    }
    
    class func convert<T: Codable>(_ object: T) -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(object) else { return nil }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data,
                                                                 options: .allowFragments) else { return nil }
        guard let json = jsonObject as? [String: Any] else { return nil }
        return json
    }
    
    class func showMessage(title: String? = nil, message: String?) {
        guard let topVC = topViewController() else { return }
        Alert.showConfirm(on: topVC, message: message)
    }
    
    class func topViewController(
        _ viewController: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
}
