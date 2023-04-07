//
//  String+ext.swift
//  SSTCloud
//
//  Created by Le Trung on 18/02/2023.
//

import Foundation

extension String {
    public static func fromClass(_ className: AnyClass) -> String {
        let classString = NSStringFromClass(className)
        if classString.contains(".") {
            return classString.components(separatedBy: ".")[1]
        }
        return classString
    }
}
