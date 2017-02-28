//
//  LoginViewModel.swift
//  loginRx
//
//  Created by zhanghao on 17/2/28.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import Foundation
import RxSwift


class LoginViewModel {
    
    let username = Variable<String>("")
    let userPwd  = Variable<String>("")
    let loginTaps = PublishSubject<Void>()
    
    let usernameValid: Observable<Bool>
    let userPwdValid: Observable<Bool>
    let loginBtnEnable: Observable<Bool>
    
    // 登录结果及逻辑
    let loginResult: Observable<Bool>
    
    init() {
        usernameValid = username.asObservable()
            .map { name in
                
                print(#function, #line, name)
                if name.characters.count >= 6 {
                    return true
                }
                return false
            }
            .shareReplay(1)
        
        userPwdValid = userPwd.asObservable()
            .map { pwd in
                if pwd.characters.count >= 6 {
                    return true
                }
                return false
            }
            .shareReplay(1)
        
        loginBtnEnable = Observable.combineLatest(usernameValid, userPwdValid) {
            return $0 && $1
        }
        
        let usernameAndPwd = Observable.combineLatest(username.asObservable(), userPwd.asObservable()) { ($0, $1) }
        
        loginResult = loginTaps.asObservable()
            .withLatestFrom(usernameAndPwd)
            .flatMapLatest { (name, pwd) -> Observable<Bool> in
                
                // 登录逻辑
                // 读取本地用户名文件，并添加到本地文件中
                guard let userArray = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [UserItem] else {
                    return Observable.just(false)
                }
                
                for user: UserItem in userArray {
                    if user.name == name && user.pwd == pwd {
                        return Observable.just(true)
                    }
                }
                return Observable.just(false)
            }
            .shareReplay(1)
        
        
        
    }
    
    
}
