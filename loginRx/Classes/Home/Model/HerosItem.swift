//
//  HerosItem.swift
//  loginRx
//
//  Created by HOWIE-CH on 17/2/28.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import Foundation

class HerosItem: NSObject{
    
    var icon: String = ""
    var name: String = ""
    var intro: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
