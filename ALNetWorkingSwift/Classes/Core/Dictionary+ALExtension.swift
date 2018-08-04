//
//  Dictionary+ALExtension.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/8.
//
//

import Foundation

extension Dictionary {
    
    func jsonStr() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .init(rawValue: 0)), data.count > 0 else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func jsonValue() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted), data.count > 0 else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
