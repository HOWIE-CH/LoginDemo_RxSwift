//
//  Protocols.swift
//  loginRx
//
//  Created by zhanghao on 17/2/27.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import UIKit

enum ValidationResult {
    case ok(message: String)
    case failed(message: String)
    case empty
}


// 计算性属性，一般只写 get 方法，get 可省略，一般不会去监听属性改变
// MARK: 计算性属性 是否验证通过
extension ValidationResult {
    
    var isValid: Bool {
        switch self {
            case .ok:
                return true
            default:
                return false
        }
    }
    
}
// MARK: 计算性属性 根据结果的颜色
extension ValidationResult {
    
    var textColor: UIColor {
        switch self {
            case .ok:
                return UIColor.purple
            case .empty:
                return UIColor.black
            case .failed:
                return UIColor.red
        }
    }
}
// MARK: 计算性属性 描述信息

extension ValidationResult {
    
    var description: String {
        // switch 中 一个是 case ： 一个是 case let ：
        // case let不是匹配值，而是值绑定
        switch self {
            case let .ok(message):
                return message
            case .empty:
                return ""
            case let .failed(message):
                return message
        }

    }
}









