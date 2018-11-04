//
//  ALHTTPRequestOperationManager.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/12.
//
//

import Foundation
import Alamofire

// 另起别名为了桥接作用
public typealias ALDataRequest = DataRequest
public typealias ALDataResponse = DataResponse
public typealias ALParameterEncoding = ParameterEncoding
public typealias ALHTTPMethod = HTTPMethod
public typealias ALURLEncoding = URLEncoding
public typealias ALJSONEncoding = JSONEncoding
public typealias ALPropertyListEncoding = PropertyListEncoding
public typealias ALMultipartFormData = MultipartFormData
public typealias ALSessionManager = SessionManager

public typealias ALHTTPManagerSetupHandle = ((ALSessionManager)->Void)

/// 网络请求基础类
open class ALHTTPRequestOperationManager {
    
    open var httpConfig: ALCommonConfigProtocol
    
    required public init(config: ALCommonConfigProtocol) {
        httpConfig = config
    }
    
    // 单例
    public static let `default`: ALHTTPRequestOperationManager = {
        return ALHTTPRequestOperationManager(config: ALCommonConfig())
    }()
    
    //MARK: - 通用方法
    /// 网络请求通用方法
    ///
    /// - Parameters:
    ///   - httpMethod: 请求方法
    ///   - urlString: 请求的url
    ///   - encoding: 参数编码方式（默认ALURLEncoding.default）
    ///   - dictHeader: 请求头
    ///   - parameter: 传入参数
    ///   - contentType: contentType设置
    ///   - preSetupHandle: 特殊处理配置
    ///   - completionHandler: 结果回调(以枚举返回)
    /// - Returns: 请求返回
    @discardableResult
    open func requestBase(httpMethod: ALHTTPMethod = .get,
                          url urlString:String,
                          urlEncoding encoding: ALParameterEncoding = ALURLEncoding.default,
                          header dictHeader:[String : String]? = nil,
                          parameter:[String : Any]?,
                          contentType: Set<String>? = nil,
                          preSetupHandle: ALHTTPManagerSetupHandle? = nil,
                          completionHandler: @escaping (ALDataResponse<Any>) -> Void)
        -> ALDataRequest
    {
        
        preSetupHandle?(Alamofire.SessionManager.default)
        
        //Header的处理
        let header = self.httpConfig.getHeader(dictHeader: dictHeader)
        
        //contentType
        let content = self.httpConfig.getContentType(contentType: contentType)
        
        let request = Alamofire.request(urlString, method: httpMethod, parameters: parameter, encoding: encoding, headers: header)
            .validate(contentType: content)
            .responseJSON(completionHandler: completionHandler)
        return request
    }
    
    /// POST上传文件最终通用方法
    ///
    /// - Parameters:
    ///   - urlString: 请求的url
    ///   - dictHeader: 请求头
    ///   - parameter: 传入参数
    ///   - preSetupHandle: 特殊处理配置
    ///   - multipartFormData: 文件传入处理
    ///   - encodingCompletion: 结果回调(以枚举返回)
    open func uploadBase(url urlString:String,
                         header dictHeader:[String : String]? = nil,
                         parameter:[String : Any]? = [String : Any](),
                         preSetupHandle: ALHTTPManagerSetupHandle? = nil,
                         multipartFormData: @escaping ((MultipartFormData)->Void),
                         encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?)
    {
        
        preSetupHandle?(Alamofire.SessionManager.default)
        
        //Header的处理
        let header = self.httpConfig.getHeader(dictHeader: dictHeader)
        
        Alamofire.upload(multipartFormData: { (formData) in
            
            for (key, value) in parameter! {
                let v = String(describing: value)
                formData.append(v.data(using: .utf8)!, withName: key)
            }
            
            multipartFormData(formData)
        }, to: urlString, method: .post, headers: header, encodingCompletion: encodingCompletion)
        
    }
    
}
