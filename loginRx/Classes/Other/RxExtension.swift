//
//  RxExtension.swift
//  loginRx
//
//  Created by zhanghao on 17/2/28.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: RX 扩展 计算型属性
// textfield 展示验证后的结果能否输入，验证过了才能输入
extension Reactive where Base: UITextField {
    
    var inputEnable: UIBindingObserver<Base, ValidationResult> {
        return UIBindingObserver(UIElement: base,
                                 binding: { (textField, result) in
                                    
            textField.isEnabled = result.isValid
        })
    }
}

// label 展示验证后的结果
extension Reactive where Base: UILabel {
    
    var validResult: UIBindingObserver<Base, ValidationResult>  {
        
        return UIBindingObserver(UIElement: base,
                                 binding: {(label, result) in
            switch result {
                case .empty:
                    label.isHidden = true
                default:
                    
                    label.isHidden  = false
                    label.textColor = result.textColor
                    label.text = result.description
            }
        })
        
    }
}

//// button 验证了才能 点击
//// 根据验证信息 序列 来 判断能否点击
//extension Reactive where Base: UIBarButtonItem {
//    
//    var tapEnable: UIBindingObserver<Base, ValidationResult> {
//        
//        return UIBindingObserver(UIElement: base,
//                                 binding: { (button, result) in
//                                    
//            print(#function, #line, result.isValid)
//            button.isEnabled = result.isValid
//        })
//    }
//}
