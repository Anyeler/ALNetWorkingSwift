//
//  ALHTTPResponse.swift
//  Pods
//
//  Created by anyeler.zhang on 2017/9/11.
//
//

import Foundation
import HandyJSON

/*******************************************************************************
 * 网络请求返回的基本协议
 * 说明：继承此协议规定网络响应的返回结构，此协议支持 class, protocol, struct 继承
 * 例子：ALNetHTTPResponse.swift
 *******************************************************************************/

public protocol ALHTTPResponse: HandyJSON { }
