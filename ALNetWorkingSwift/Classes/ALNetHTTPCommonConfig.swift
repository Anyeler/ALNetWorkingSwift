//
//  ALNetHTTPCommonConfig.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/7.
//
//

import Foundation

/// 基础配置类
public struct ALNetHTTPCommonConfig {
    
    //MARK: - 程序启动设置的变量
    //app名字（通常是多端登录标识平台来源）
    public static var appName:        String    = "" {
        didSet {
            ALNetHTTPRequestParameter.share.appName = appName
        }
    }
    //接口版本号
    public static var version:        String    = "1.0" {
        didSet {
            ALNetHTTPRequestParameter.share.version = version
        }
    }
    //系统标识
    public static var appostype:      Int       = 2 {
        didSet {
            ALNetHTTPRequestParameter.share.appostype = appostype
        }
    }
    //用户ID
    public static var uid:            Int       = 0 {
        didSet {
            ALNetHTTPRequestParameter.share.uid = uid
        }
    }
    //appID(私有APP标识)
    public static var kAppId:         Int       = 0 {
        didSet {
            ALNetHTTPRequestParameter.share.appid = kAppId
        }
    }
    //用户Token
    public static var token:          String    = "" {
        didSet {
            ALNetHTTPRequestParameter.share.ticket = token
        }
    }
    //用户下载渠道（默认APPStore）
    public static var kChannelId:     String    = "appstore" {
        didSet {
            ALNetHTTPRequestParameter.share.channel = kChannelId
        }
    }
    //Host地址
    public static var kDefaultUrl:    String    = ""
    
    //自定义的UserAgent
    public static var kHttpUserAgent: String    = "" {
        didSet {
            ALHTTPRequestOperationManager.default.httpConfig.kHttpUserAgent = kHttpUserAgent
        }
    }
    
    //是否需要加入公参
    public static var isExtenedComonParam: Bool = false
    // 私参的Key，默认最顶部
    public static var kParameter_private_args   = ""
    // 公参的key，默认最顶部
    public static var kParameter_public_args    = ""
    
    init() {
        
        
    }
}
