//
//  ALCommonConfigProtocol.swift
//  Pods
//
//  Created by anyeler.zhang on 2018/7/18.
//

import UIKit

/// 网络配置通用协议，可加字段
public protocol ALCommonConfigProtocol {
    
    /// User-Agent 信息
    var kHttpUserAgent: String { get set }
    
    /// 根据配置信息返回最终头部信息
    ///
    /// - Parameter dictHeader: 接口临时自定义头部
    /// - Returns: 返回最终头部信息
    func getHeader(dictHeader: [String: String]?) -> [String: String]
    
    /// 根据配置信息返回最终 ContentType
    ///
    /// - Parameter contentType: 接口自定义 ContentType
    /// - Returns: 返回最终 ContentType
    func getContentType(contentType: Set<String>?) -> Set<String>
}

/// 核心模块通用配置
public struct ALCommonConfig: ALCommonConfigProtocol {
    
    public var kHttpUserAgent: String = ""
    
    init() {
        
    }
    
    public func getHeader(dictHeader: [String: String]? = nil) -> [String: String] {
        var header: [String:String] = [String: String]()
        
        if self.kHttpUserAgent.count > 0 {
            header.merge(self.commonHeaderField()) { (_, new) in new }
        }
        if dictHeader != nil {
            header.merge(dictHeader!) { (_, new) in new }
        }
        return header
    }
    
    public func getContentType(contentType: Set<String>? = nil) -> Set<String> {
        var content: Set<String> = self.acceptableContentTypes()
        contentType?.forEach({ (ele) in
            content.insert(ele)
        })
        return content
    }
    
    /// 预设支持类型
    ///
    /// - Returns: 返回预设支持类型
    internal func acceptableContentTypes() -> Set<String> {
        return ["application/json", "text/html", "text/plain"]
    }
    
    /// 预设头部信息
    ///
    /// - Returns: 返回预设头部
    internal func commonHeaderField() -> [String: String] {
        return ["User-Agent" : self.kHttpUserAgent]
    }
}
