//
//  String+Extension.swift
//  base-combine
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    var isActuallyEmpty: Bool {
        return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
