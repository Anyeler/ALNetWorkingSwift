//
//  TJHTTPRequestParameter.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/7.
//
//

import Foundation
import AdSupport

/// 公共参数类, 需要用户自行拼接进Parameter中
open class ALNetHTTPRequestParameter {
    
    open var appName: String
    // ios平台具体和后台定
    open var appostype: Int = 1
    //app版本
    open var appversion: String
    //渠道
    open var channel: String
    //广告唯一标示符 idfa
    open var idfa: String
    //设备系统版本
    open var systemversion: String
    //设备id，UUIDString
    open var device_id: String
    //接口版本号
    open var version: String = "1.0"
    //用户token
    open var ticket: String
    //用户id
    open var uid: Int = 0
    //appId
    open var appid: Int = 0
    
    //添加扩展参数
    open var extenParam: [String:Any] = [String:Any]()
    
    public static let share: ALNetHTTPRequestParameter = {
        return ALNetHTTPRequestParameter()
    }()
    
    required public init() {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        device_id = (uuid != nil) ? uuid! : "0"
        appversion = Bundle.main.infoDictionary != nil ? String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!) : ""
        idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        systemversion = UIDevice.current.systemVersion
        appostype = ALNetHTTPCommonConfig.appostype //ios
        version = ALNetHTTPCommonConfig.version //IM接口版本号
        uid = ALNetHTTPCommonConfig.uid
        channel = ALNetHTTPCommonConfig.kChannelId
        appName = ALNetHTTPCommonConfig.appName
        ticket  = ALNetHTTPCommonConfig.token
        appid = ALNetHTTPCommonConfig.kAppId
    }
    
    open func getSharedParameter() -> Dictionary<String, Any> {
        self.updateInfo()
        var dict = self.getAllPropertiesAndVaules()
        dict.removeValue(forKey: "share")
        if let exDict = dict.removeValue(forKey: "extenParam") as? [String:Any] {
            dict.merge(exDict) { (current, _) in current }
        }
        return dict
    }
    
    fileprivate func updateInfo() {
        self.uid    = ALNetHTTPCommonConfig.uid
        self.ticket = ALNetHTTPCommonConfig.token
        self.appostype = ALNetHTTPCommonConfig.appostype //ios
        self.version = ALNetHTTPCommonConfig.version //接口版本号
        self.uid = ALNetHTTPCommonConfig.uid
        self.channel = ALNetHTTPCommonConfig.kChannelId
        self.appName = ALNetHTTPCommonConfig.appName
        self.ticket  = ALNetHTTPCommonConfig.token
        self.appid = ALNetHTTPCommonConfig.kAppId
    }
    
    func propertyKeys() -> [String] {
        return Mirror(reflecting: self).children.compactMap{obj in
            return obj.label
        }
    }
    
    func getAllPropertiesAndVaules() -> [String : Any] {
        let mirror = Mirror(reflecting: self)
        var dict = [String : Any]()
        
        mirror.children.forEach { (obj) in
            guard let key = obj.label else { return }
            dict[key] = obj.value
        }
        return dict
    }
    
}
