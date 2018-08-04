//
//  DataRequest+ALExtension.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/11.
//
//

import Foundation
import Alamofire

extension DataRequest {
    
    enum ErrorCode: Int {
        case noData = 1
        case dataSerializationFailed = 2
    }
    
    internal static func newError(_ code: ErrorCode, failureReason: String) -> NSError {
        let errorDomain = "com.alamofireobjectmapper.error"
        
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let returnError = NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        
        return returnError
    }
    
    /// Utility function for checking for errors in response
    internal static func checkResponseForError(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        if let error = error {
            return error
        }
        guard let _ = data else {
            let failureReason = "Data could not be serialized. Input data was nil."
            let error = newError(.noData, failureReason: failureReason)
            return error
        }
        return nil
    }
    
    /// Utility function for extracting JSON from response
    internal static func processResponse(request: URLRequest?, response: HTTPURLResponse?, data: Data?, keyPath: String? = nil) -> Any? {
        let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
        let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
        
        let JSON: Any?
        if let keyPath = keyPath , keyPath.isEmpty == false {
            JSON = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
        } else {
            JSON = result.value
        }
        
        return JSON
    }
    
    //MARK: - ObjectSerializer
    //MARK: 解析方法
    /// BaseMappable Object Serializer
    public static func ObjectMapperSerializer<T: ALHTTPResponse>(_ keyPath: String?) -> DataResponseSerializer<T> {
        
        return DataResponseSerializer { request, response, data, error in
            if let error = checkResponseForError(request: request, response: response, data: data, error: error){
                return .failure(error)
            }
            
            let JSONObject = processResponse(request: request, response: response, data: data, keyPath: keyPath)
            
            if let jsonStr = JSONObject as? String, let obj = T.deserialize(from: jsonStr, designatedPath: keyPath) {
                return .success(obj)
            }
            
            if let json = JSONObject as? NSDictionary, let obj = T.deserialize(from: json, designatedPath: keyPath) {
                return .success(obj)
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = newError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
    }
    
    //MARK: 调用方法
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue:             The queue on which the completion handler is dispatched.
     - parameter keyPath:           The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    @discardableResult
    public func responseObject<T: ALHTTPResponse>(queue: DispatchQueue? = nil, keyPath: String? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperSerializer(keyPath), completionHandler: completionHandler)
    }
    
    
    //MARK: - ArraySerializer
    //MARK: 解析方法
    /// BaseMappable Array Serializer
    public static func ObjectMapperArraySerializer<T: ALHTTPResponse>() -> DataResponseSerializer<[T]> {
        
        return DataResponseSerializer { request, response, data, error in
            if let error = checkResponseForError(request: request, response: response, data: data, error: error){
                return .failure(error)
            }
            
            let JSONObject = processResponse(request: request, response: response, data: data)
            
            if let jsonStr = JSONObject as? String, let obj = [T].deserialize(from: jsonStr) as? [T] {
                return .success(obj)
            }
            
            if let json = JSONObject as? NSArray, let obj = [T].deserialize(from: json) as? [T] {
                return .success(obj)
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = newError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
    }
    
    //MARK: 调用方法
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue:             The queue on which the completion handler is dispatched.
     - parameter keyPath:           The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    @discardableResult
    public func responseArray<T: ALHTTPResponse>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperArraySerializer(), completionHandler: completionHandler)
    }
       
    
}
