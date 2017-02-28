//
//  RegiestViewModel.swift
//  loginRx
//
//  Created by zhanghao on 17/2/27.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import Foundation
import RxSwift

/// 最小字符数
let charactersCount = 6
/// 用户文件
let filePath = NSHomeDirectory() + "/Documents/users.plist"

// 类不继承 NSObject，原生类
class RegiestViewModel {
    // MARK: 属性
    
    // input 监听数据      用于 UI 控件值 绑定 VM
    // Variable PublishSubject subject 的一种，可当观察者被 bindTo，可当序列数据源 Observable
    // 它不会因为错误终止也不会正常终止, 适合做数据源
    let username = Variable<String>("")
    let userPwd  = Variable<String>("")
    let repeatPwd = Variable<String>("")
    // 按钮点击 绑定的 PublishSubject
    let registerTaps = PublishSubject<Void>()
    
    // output 发送序列  用于 VM 绑定 UI ，UI 控件值绑定后，产生序列后，在返回显示到 UI 界面上
    let usernameValid: Observable<ValidationResult>
    let passwordValid: Observable<ValidationResult>
    let repeatPwdValid: Observable<ValidationResult>
    let registerButtonEnabled: Observable<Bool>
    // 注册按钮的点击 注册结果
    let registeResult: Observable<ValidationResult>
    
    
    init() {
        
        // 需要初始化 usernameValid passwordValid repeatPwdValid registerButtonEnabled 这几个没有默认值的属性
        
        // 用户名位数验证
        usernameValid = username.asObservable()
            .flatMapLatest{ username -> Observable<ValidationResult> in
                
                print(#function, #line, username)
                if username.characters.count == 0 {
                    return Observable.just(ValidationResult.empty)
                }
                if username.characters.count < charactersCount {
                    return Observable.just(ValidationResult.failed(message: "位数不能少于\(charactersCount)位"))
                }
                
                // 是否重名
                guard let array = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [UserItem]  else {
                    
                    return Observable.just(ValidationResult.ok(message: "正确"))
                }
                
                for user: UserItem in array {
                    if user.name == username {
                        return Observable.just(ValidationResult.failed(message: "重名"))
                    }
                }
                
                return Observable.just(ValidationResult.ok(message: "正确"))
        }
            .shareReplay(1)
        
        // 密码位数验证   map 不会产生新的序列， flatMapLatest 会产生新的序列 combineLatest 不会产生新的序列
        passwordValid = Observable.combineLatest(username.asObservable(), userPwd.asObservable()) { (name, userPwd) in
            
                if userPwd.characters.count == 0 {
                    return ValidationResult.empty
                }
                if userPwd.characters.count < charactersCount {
                    return ValidationResult.failed(message: "位数不能少于\(charactersCount)位")
                }
            
                // 增加用户名不能喝密码相同的判断
                if userPwd == name {
                    return ValidationResult.failed(message: "用户名和密码不能相同")
                }
                return ValidationResult.ok(message: "位数正确")
            
            }
            .shareReplay(1)

        
        
        /*
         passwordValid = userPwd.asObservable()
             .map { userPwd -> ValidationResult in
                 if userPwd.characters.count == 0 {
                 return ValidationResult.empty
                 }
                 if userPwd.characters.count < charactersCount {
                 return ValidationResult.failed(message: "位数不能少于\(charactersCount)位")
                 }
                 
                 return ValidationResult.ok(message: "位数正确")
                 
             }
         .shareReplay(1)
         */
        
        
        
        
        // 重复密码
        repeatPwdValid = Observable.combineLatest(userPwd.asObservable(), repeatPwd.asObservable()) { (userPwd, repeatPwd) -> ValidationResult in
            
            if userPwd.characters.count == 0 || repeatPwd.characters.count == 0 {
                return ValidationResult.empty
            }
            
            if userPwd == repeatPwd && userPwd.characters.count != 0 {
                return ValidationResult.ok(message: "两次密码一致")
            }
            return ValidationResult.failed(message: "两次密码不同，请重新输入")
        }
            .shareReplay(1)
        
        // 注册按钮是否可以点击
        registerButtonEnabled = Observable.combineLatest(usernameValid, passwordValid, repeatPwdValid) {
            (name, pwd, secondPwd) -> Bool in
            if name.isValid && pwd.isValid && secondPwd.isValid {
                return true
            }
            return false
        }
            .shareReplay(1)
        
        let usernameAndPwd = Observable.combineLatest(username.asObservable(), userPwd.asObservable()) { ($0, $1) } // 无操作，仅仅是 usernameAndPwd 有两个 String 型的参数 ，用于后面将注册的用户名及密码等保存本地
            
        // 注册结果  withLatestFrom flatMapLatest
        registeResult = registerTaps.asObservable()
            .withLatestFrom(usernameAndPwd)
            .flatMapLatest { (name, pwd) -> Observable<ValidationResult> in
                
                if name.characters.count == 0 || pwd.characters.count == 0  {
                    return Observable.just(ValidationResult.failed(message: "不能为空"))
                }
                
                let user = UserItem(name: name, pwd: pwd)
                
                // 读取本地用户名文件，并添加到本地文件中
                guard var userArray = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [UserItem] else {
                    
                    var array = [UserItem]()
                    array.append(user)
                    
                    NSKeyedArchiver.archiveRootObject(array, toFile: filePath)
                    return Observable.just(ValidationResult.ok(message: "注册成功"))
                   

                }
                userArray.append(user)
                NSKeyedArchiver.archiveRootObject(userArray, toFile: filePath)
                return Observable.just(ValidationResult.ok(message: "注册成功"))
        }
        .shareReplay(1)
        
        
    }
    
}
