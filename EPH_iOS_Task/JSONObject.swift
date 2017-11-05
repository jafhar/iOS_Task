//
//  JSONObject.swift
//  EPH_iOS_Task
//
//  Created by Jafhar Sharief B on 05/11/17.
//  Copyright © 2017 Jafhar. All rights reserved.
//

import Foundation

// MARK: - Helper for parsing serialised json
typealias JSONObject = [String: Any]

protocol JSONObjectKey {
    var stringValue: String { get }
}

extension RawRepresentable where RawValue == String {
    var stringValue: String {
        return rawValue
    }
}

protocol JSONObjectValue {}

extension Bool: JSONObjectValue {}
extension String: JSONObjectValue {}
extension Int: JSONObjectValue {}
extension Dictionary: JSONObjectValue {}
extension Array: JSONObjectValue {}

extension Dictionary where Key == String, Value: Any {
    func value<V: JSONObjectValue>(forKey key: JSONObjectKey) -> V? {
        return self[key.stringValue] as? V
    }
}
