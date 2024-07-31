//
//  NetworkErrorType.swift
//  Base-ios
//
//  Created by Than Van Thanh on 31/7/24.
//

import Foundation

enum NetworkErrorType: Int, Error {
    case UNAUTHORIZED = 401
    case INVALID_TOKEN = 403
}
