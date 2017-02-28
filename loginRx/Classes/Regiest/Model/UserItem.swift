//
//  UserItem.swift
//  loginRx
//
//  Created by zhanghao on 17/2/28.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import Foundation

class UserItem: NSObject, NSCoding{
    var name: String = ""
    var pwd: String  = ""
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: "name")
        aCoder.encode(pwd, forKey: "pwd")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        let name  = aDecoder.decodeObject(forKey: "name") as? String
        let pwd   = aDecoder.decodeObject(forKey: "pwd") as? String

        self.name = name ?? ""
        self.pwd  = pwd ?? ""

        super.init()
    }
    
    // MARK: 自定义构造函数
    init(name: String, pwd: String) {
        super.init()
        self.name = name
        self.pwd  = pwd
    }

}
