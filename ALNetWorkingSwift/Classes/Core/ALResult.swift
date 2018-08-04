//
//  ALResult.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/9.
//
//

import Foundation

/// 网络响应返回结果枚举
///
/// - success: 成功返回附带数据
/// - failure: 失败返回附带数据
public enum ALResult<Value> {
    case success(Value)
    case failure(Value)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Value? {
        switch self {
        case .success:
            return nil
        case .failure(let Value):
            return Value
        }
    }
}
