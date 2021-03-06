# ALNetWorkingSwift

ALNetWorkingSwift is mainly provided for internal Swift projects within the company. So far, network request-related operations have been integrated, including the data mapping module.

[![CI Status](https://img.shields.io/travis/Anyeler/ALNetWorkingSwift.svg?style=flat)](https://travis-ci.org/Anyeler/ALNetWorkingSwift)
[![Version](https://img.shields.io/cocoapods/v/ALNetWorkingSwift.svg?style=flat)](https://cocoapods.org/pods/ALNetWorkingSwift)
[![License](https://img.shields.io/cocoapods/l/ALNetWorkingSwift.svg?style=flat)](https://cocoapods.org/pods/ALNetWorkingSwift)
[![Platform](https://img.shields.io/cocoapods/p/ALNetWorkingSwift.svg?style=flat)](https://cocoapods.org/pods/ALNetWorkingSwift)

## [中文文档](./README_CN.md)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+
- Xcode 9.3+
- Swift 4.1+

## Installation

ALNetWorkingSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ALNetWorkingSwift'
    # You can also load only core modules:
    # pod 'ALNetWorkingSwift/Core'
end
```

## Basic usage of core modules

### Making request
You can invoke the method to initiate a common network request:
```swift
ALHTTPRequestOperationManager.default.requestBase(httpMethod: .get, url: "https://www.baidu.com", urlEncoding: TURLEncoding.default, parameter: nil) { (response) in        
    switch response.result {
    case .success(let res):
        print(res)
    case .failure(let err):
        print(err)
    }
}
```

You can also call the following methods to upload data:

```swift
ALHTTPRequestOperationManager.default.uploadBase(url: "https://www.baidu.com", multipartFormData: { (formData) in
    // The assembly to upload data
}) { (result) in
    switch result {
    case .success(let request, let streamingFromDisk, let streamFileURL):
        print(request)
        print(streamingFromDisk)
        print(streamFileURL ?? "")
    case .failure(let err):
        print(err)
    }
}
```



### Advanced usage
You can also re-encapsulate both approaches to meet your business requirements.

#### Configuration
To conform to `ALCommonConfigProtocol`, a struct need to implement Some properties and methods:

```swift
public struct HTTPConfig: ALCommonConfigProtocol {
    
    public var kHttpUserAgent: String = ""
    
    init() {
        
    }
    
    public func getHeader(dictHeader: [String: String]? = nil) -> [String: String] {
        var header: [String:String] = [String: String]()
        if dictHeader != nil {
            header.merge(dictHeader!) { (_, new) in new }
        }
        return header
    }
    
    public func getContentType(contentType: Set<String>? = nil) -> Set<String> {
        var content: Set<String> = Set<String>()
        contentType?.forEach({ (ele) in
            content.insert(ele)
        })
        return content
    }
}
```

Then, Call this method:

```swift
ALHTTPRequestOperationManager.default.httpConfig = HTTPConfig()
```

## Author

Anyeler, 414116969@qq.com

## License

ALNetWorkingSwift is available under the MIT license. See the LICENSE file for more info.
