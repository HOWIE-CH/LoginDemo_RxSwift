//
//  LoginViewController.swift
//  loginRx
//
//  Created by zhanghao on 17/2/28.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPwdTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    fileprivate let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginViewModel = LoginViewModel()
        // 绑定
        usernameTextField.rx.text.orEmpty
            .bindTo(loginViewModel.username)
            .addDisposableTo(disposeBag)
        
        userPwdTextField.rx.text.orEmpty
            .bindTo(loginViewModel.userPwd)
            .addDisposableTo(disposeBag)
        loginBtn.rx.tap
            .bindTo(loginViewModel.loginTaps)
            .addDisposableTo(disposeBag)
        
        
        // 绑定
        loginViewModel.usernameValid
            .bindTo(userPwdTextField.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        loginViewModel.loginBtnEnable
            .bindTo(loginBtn.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        loginViewModel.loginResult
            .subscribe(onNext: { [weak self] result in
                if result {
                    self?.showAlter(message: "登录成功！")
                } else {
                    self?.showAlter(message: "用户名或密码不正确")
                }
                
            })
            .addDisposableTo(disposeBag)
        
        
        
    }

 
}

extension LoginViewController {
    
    func showAlter(message: String) -> Void {
        let alterVc = UIAlertController(title: "登录",
                                        message: "\(message)",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "好的", style: .default) { (action) in
            // 跳转到首页
            DispatchQueue.main.asyncAfter(deadline: .now(),
                                          execute: { [weak self] in
                                            
                let home = HomeViewController()
                home.title = self?.usernameTextField.text
                self?.navigationController?.pushViewController(home, animated: true)
                })
            
        }
        
        alterVc.addAction(action)
        
        present(alterVc, animated: true, completion: nil)
    }

}
