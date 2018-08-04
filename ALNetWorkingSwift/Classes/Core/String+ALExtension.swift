//
//  String+ALExtension.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/11.
//
//

import Foundation

extension String {
    
    func jsonStrToDict() -> [String : Any]? {
        guard let str = (self as NSString).removingPercentEncoding else { return nil }
        guard let data = str.data(using: String.Encoding.utf8) else { return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else { return nil }
        return dict
    }
}
