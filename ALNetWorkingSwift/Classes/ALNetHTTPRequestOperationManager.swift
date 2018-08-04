//
//  TJHTTPRequestOperationManager.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/7.
//
//

import Foundation

public typealias ALNetRequestResponse<T: ALNetHTTPResponse> = ((ALResult<T>)->Void)

/// 网络请求调用类
open class ALNetHTTPRequestOperationManager {
    
    //MARK: - 通用方法(包含映射机制)
    
    /// 通用网络请求（参数个选择性输入）
    ///
    /// - Parameters:
    ///   - httpMethod: 请求方法
    ///   - urlString: host地址
    ///   - urlEncoding: URL编码（默认ALURLEncoding）
    ///   - dictHeader: 请求头
    ///   - parameter: 传入参数
    ///   - contentType: contentTypep配置
    ///   - preSetupHandle: 特殊配置
    ///   - completionHandler: 结果返回回调
    /// - Returns: 请求返回
    @discardableResult
    open class func request<T: ALNetHTTPResponse>(
        httpMethod: ALHTTPMethod = .get,
        url urlString: String = ALNetHTTPCommonConfig.kDefaultUrl,
        urlEncoding encoding: ALParameterEncoding = ALURLEncoding.default,
        header dictHeader:[String : String]? = nil,
        parameter:[String : Any] = [String : Any](),
        contentType: Set<String>? = nil,
        preSetupHandle: ALHTTPManagerSetupHandle? = nil,
        completionHandler: ALNetRequestResponse<T>?)
        -> ALDataRequest
    {
        
        let param = self.getParameter(encoding: encoding, userParameter: parameter)
        
        let request = ALHTTPRequestOperationManager.default.requestBase(httpMethod: httpMethod, url: urlString, urlEncoding: encoding, header: dictHeader, parameter: param, contentType: contentType, preSetupHandle: preSetupHandle) { (response) in
            //打印
            
            #if DEBUG
                print("=============================REQUEST:\nGET "+urlString)
                print("parameter:\n"+"\(param.jsonValue())")
                print("=============================RESPONSE:")
                switch response.result {
                case .success(_):
                    print(response)
                case .failure(_):
                    guard let errData = response.data else {
                        print(response)
                        return
                    }
                    guard let errStr = String(data: errData, encoding: .utf8) else {
                        print(response)
                        return
                    }
                    print(errStr)
                }
            #endif
        }
        
        request.responseObject { (response: ALDataResponse<T>) in
            switch response.result {
            case .success(let res):
                var resSuccess = res
                if response.error != nil {
                    let err = response.error! as NSError
                    resSuccess.error = response.error
                    resSuccess.errorMsg = err.domain
                }
                completionHandler?(.success(resSuccess))
            case .failure(let error):
                let err = error as NSError
                var res = T()
                res.error = error
                res.status = err.code
                res.errorMsg = err.domain
                completionHandler?(.failure(res))
            }
        }
        
        return request
    }
    
    /// 通用upload请求（参数个选择性输入）
    ///
    /// - Parameters:
    ///   - urlString: host地址
    ///   - dictHeader: 请求头
    ///   - parameter: 传入参数
    ///   - localFiles: 上传文件字典
    ///   - preSetupHandle: 特殊配置
    ///   - multipartFormData: 本地文件处理后的修改处理
    ///   - completionHandler: 结果返回回调
    open class func upload<T: ALNetHTTPResponse>(
        url urlString: String = ALNetHTTPCommonConfig.kDefaultUrl,
        header dictHeader:[String : String]? = nil,
        parameter:[String : Any] = [String : Any](),
        localFiles:[String : Any] = [String : Any](),
        preSetupHandle: ALHTTPManagerSetupHandle? = nil,
        multipartFormData: @escaping ((ALMultipartFormData)->Void),
        completionHandler: ALNetRequestResponse<T>?)
    {
        
        ALHTTPRequestOperationManager.default.uploadBase(url: urlString, header: dictHeader, parameter: parameter, preSetupHandle: preSetupHandle, multipartFormData: { (formData) in
            
            if let dataDict = localFiles as? [String : Data] {
                for (key, value) in dataDict {
                    formData.append(value, withName: key)
                }
                return
            }
            
            guard let files = localFiles as? [String : String] else { return }
            for (key, value) in files {
                let file = URL(fileURLWithPath: value, isDirectory: false)
                formData.append(file, withName: key)
            }
            multipartFormData(formData)
        }) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    //打印
                    #if DEBUG
                        print("=============================REQUEST:\nPOST "+urlString)
                        print("parameter:\n"+"\(parameter.jsonValue())")
                        print("=============================RESPONSE:")
                        switch response.result {
                        case .success(_):
                            print(response)
                        case .failure(_):
                            guard let errData = response.data else {
                                print(response)
                                return
                            }
                            guard let errStr = String(data: errData, encoding: .utf8) else {
                                print(response)
                                return
                            }
                            print(errStr)
                        }
                    #endif
                }
                
                upload.responseObject(completionHandler: { (response: ALDataResponse<T>) in
                    switch response.result {
                    case .success(let res):
                        var resSuccess = res
                        if response.error != nil {
                            let err = response.error! as NSError
                            resSuccess.error = response.error
                            resSuccess.errorMsg = err.domain
                        }
                        completionHandler?(.success(resSuccess))
                    case .failure(let error):
                        let err = error as NSError
                        var res = T()
                        res.error = error
                        res.status = err.code
                        res.errorMsg = err.domain
                        completionHandler?(.failure(res))
                    }
                })
                
            case .failure(let encodingError):
                let err = encodingError as NSError
                var res = T()
                res.error = encodingError
                res.status = err.code
                res.errorMsg = err.domain
                completionHandler?(.failure(res))
            }
        }
    }
    
    //MARK: Private Method
    /// 返回总的请求参数
    ///
    /// - Parameters:
    ///   - encoding: URL编码
    ///   - userParameter: 用户输入的参数
    /// - Returns: 返回所有参数列表
    fileprivate class func getParameter(encoding: ALParameterEncoding, userParameter: [String : Any]) -> [String : Any] {
        // 是否需要拼接公参
        guard ALNetHTTPCommonConfig.isExtenedComonParam else {
            return userParameter
        }
        
        // 获取公参
        let commonDict = ALNetHTTPRequestParameter.share.getSharedParameter()
        
        var dictParameter = [String : Any]()
        
        // 没有私参和公参的Key的拼接方式
        if ALNetHTTPCommonConfig.kParameter_private_args.isEmpty && ALNetHTTPCommonConfig.kParameter_public_args.isEmpty {
            dictParameter.merge(commonDict) { (_, new) in new }
            dictParameter.merge(userParameter) { (_, new) in new }
            return dictParameter
        }
        
        // 只有私参的Key的拼接方式
        if ALNetHTTPCommonConfig.kParameter_private_args.isEmpty {
            dictParameter = userParameter
            dictParameter[ALNetHTTPCommonConfig.kParameter_public_args] = (encoding is ALURLEncoding) ? commonDict.jsonStr() : commonDict
            return dictParameter
        }
        
        // 只有公参的Key的拼接方式
        if ALNetHTTPCommonConfig.kParameter_public_args.isEmpty {
            dictParameter = commonDict
            dictParameter[ALNetHTTPCommonConfig.kParameter_private_args] = (encoding is ALURLEncoding) ? userParameter.jsonStr() : userParameter
            return dictParameter
        }
        
        //有所有Key的拼接方式
        switch encoding {
        case is ALURLEncoding:
            dictParameter[ALNetHTTPCommonConfig.kParameter_private_args] = userParameter.jsonStr()
            dictParameter[ALNetHTTPCommonConfig.kParameter_public_args] = commonDict.jsonStr()
        case is ALJSONEncoding:
            dictParameter[ALNetHTTPCommonConfig.kParameter_private_args] = userParameter
            dictParameter[ALNetHTTPCommonConfig.kParameter_public_args] = commonDict
        default:
            dictParameter = userParameter
        }
        
        return dictParameter
    }
}
