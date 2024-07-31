//
//  BaseErrorResponse.swift
//  Base-ios
//
//  Created by Than Van Thanh on 31/7/24.
//

import Foundation

class ErrorResponse: Codable {
    // var errorCode: Int?
    var errorDescription: String?
}

class BaseErrorResponse: Codable {
    var errorCode: Int?
    var message: String?
    var errors: [ErrorResponse]?
}
