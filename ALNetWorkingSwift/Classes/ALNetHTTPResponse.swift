//
//  ALHTTPResponse.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/7.
//
//

import Foundation
import HandyJSON

/// 返回格式基本协议
public protocol ALNetHTTPResponse: ALHTTPResponse {
    associatedtype T
    var action:     String? { get set } //接口Action
    var version:    String? { get set } //接口版本号
    var status:     Int     { get set } //错误编码 0、200表示一切正常或操作成功
    var allRows:    Int     { get set } //符合条件的总信息数
    var error:      Error?  { get set } //请求不成功返回的错误，网络错误，解析错误等
    var errorMsg:   String? { get set } //接口返回错误代码
    var result:     T?      { get set } //数据
    
    init()
}

extension ALNetHTTPResponse {
    
    /// 自定义映射方法（可重写）
    ///
    /// - Parameter mapper: 映射管理类
    public mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<<
            self.allRows    <-- ["allRows"]
        
        mapper <<<
            self.status     <-- ["status"]
        
        mapper <<<
            self.errorMsg   <-- ["errorMsg"]
        
        mapper <<<
            self.result     <-- ["result"]
        
    }
    
}

/// 通用返回结构体
public struct ALNetHTTPResponseAny: ALNetHTTPResponse {
    public var action:     String?
    public var version:    String?
    public var status:     Int = 0
    public var allRows:    Int = 0
    public var error:      Error?
    public var errorMsg:   String?
    public var result:     Any?
    
    public init() { }
    
}

public struct ALNetHTTPResponseObject<T>: ALNetHTTPResponse {
    public var action:     String?
    public var version:    String?
    public var status:     Int = 0
    public var allRows:    Int = 0
    public var error:      Error?
    public var errorMsg:   String?
    public var result:     T?
    
    public init() { }
    
}

public struct ALNetHTTPResponseModel<ModelClass: ALHTTPResponse>: ALNetHTTPResponse {
    public var action:     String?
    public var version:    String?
    public var status:     Int = 0
    public var allRows:    Int = 0
    public var error:      Error?
    public var errorMsg:   String?
    public var result:     ModelClass?
    
    public init() { }
    
}

public struct ALNetHTTPResponseModelArray<ModelClass: ALHTTPResponse>: ALNetHTTPResponse {
    public var action:     String?
    public var version:    String?
    public var status:     Int = 0
    public var allRows:    Int = 0
    public var error:      Error?
    public var errorMsg:   String?
    public var result:     [ModelClass]?
    
    public init() { }
    
}

public struct ALNetHTTPResponseArray<T>: ALNetHTTPResponse {
    public var action:     String?
    public var version:    String?
    public var status:     Int = 0
    public var allRows:    Int = 0
    public var error:      Error?
    public var errorMsg:   String?
    public var result:     [T]?
    
    public init() { }
}

public struct ALNetHTTPResponseDictionary: ALNetHTTPResponse {
    public var action:     String?
    public var version:    String?
    public var status:     Int = 0
    public var allRows:    Int = 0
    public var error:      Error?
    public var errorMsg:   String?
    public var result:     [String : Any]?
    
    public init() { }
}

public struct ALNetHTTPResponseString: ALNetHTTPResponse {
    public var action:     String?
    public var version:    String?
    public var status:     Int = 0
    public var allRows:    Int = 0
    public var error:      Error?
    public var errorMsg:   String?
    public var result:     String?
    
    public init() { }
}
