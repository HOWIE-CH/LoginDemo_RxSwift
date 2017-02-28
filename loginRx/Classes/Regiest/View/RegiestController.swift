//
//  ViewController.swift
//  loginRx
//
//  Created by zhanghao on 17/2/27.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RegiestController: UIViewController {
    
    // MARK: 属性
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameTipLabel: UILabel!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var pwdTipLabel: UILabel!
    @IBOutlet weak var regiestBtn: UIButton!
    @IBOutlet weak var repeatPwdTextField: UITextField!
    @IBOutlet weak var repeatPwdTipLabel: UILabel!
    
    @IBOutlet weak var loginVcBtn: UIButton!
    
    fileprivate let disposeBag = DisposeBag()
    
    

    // MARK: 内部方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let regiestViewModel = RegiestViewModel()
        
        // 这里做绑定： UI控件 --> VM    VM -> UI控件
        // 1.UI控件 --> VM
        nameTextField.rx.text.orEmpty
            .bindTo(regiestViewModel.username)
            .addDisposableTo(disposeBag)
        
        pwdTextField.rx.text.orEmpty
            .bindTo(regiestViewModel.userPwd)
            .addDisposableTo(disposeBag)
        
        repeatPwdTextField.rx.text.orEmpty
            .bindTo(regiestViewModel.repeatPwd)
            .addDisposableTo(disposeBag)
        
        regiestBtn.rx.tap
            .bindTo(regiestViewModel.registerTaps)
            .addDisposableTo(disposeBag)
        
        // 2.VM -> UI控件
        // 显示结果的 label 上
        regiestViewModel.usernameValid
            .bindTo(nameTipLabel.rx.validResult)
            .addDisposableTo(disposeBag)
        // 绑定 密码框是否可以输入
        regiestViewModel.usernameValid
            .bindTo(pwdTextField.rx.inputEnable)
            .addDisposableTo(disposeBag)
        
        regiestViewModel.passwordValid
            .bindTo(pwdTipLabel.rx.validResult)
            .addDisposableTo(disposeBag)
        regiestViewModel.passwordValid
            .bindTo(repeatPwdTextField.rx.inputEnable)
            .addDisposableTo(disposeBag)
        
        regiestViewModel.repeatPwdValid
            .bindTo(repeatPwdTipLabel.rx.validResult)
            .addDisposableTo(disposeBag)
        
        // 按钮不是绑定， 按钮是 subcribe, 需要操作的
        regiestViewModel.registerButtonEnabled
            .subscribe (onNext: { [weak self]  (result) in
                
                self?.regiestBtn.isEnabled = result
                self?.regiestBtn.alpha = result ? 1 : 0.8
                
                })
            .addDisposableTo(disposeBag)
        
        // 注册结果 ： 注册成果或失败 要展示在 UI 上
        regiestViewModel.registeResult
            .subscribe(onNext:{ [weak self] result in
                switch result {
                    case let .failed(message):
                        self?.showAlter(message: message)
                    case let .ok(message):
                        self?.showAlter(message: message)
                    case .empty:
                        self?.showAlter(message: "")
                    }
                })
            .addDisposableTo(disposeBag)
        
        
        
        // 跳转到登录界面按钮的点击
        loginVcBtn.rx.tap
            .subscribe(onNext: {
                let loginVc = LoginViewController()
                loginVc.title = "请登录"
                self.navigationController?.pushViewController(loginVc, animated: true)
            })
            .addDisposableTo(disposeBag)
        
        
    }
    

}

extension RegiestController {
    
    func showAlter(message: String) -> Void {
        let alterVc = UIAlertController(title: "注册",
                                      message: "\(message)",
                               preferredStyle: .alert)
        let action = UIAlertAction(title: "好的", style: .default) { [weak self] (action) in
            // 清空啊 或者 跳转登录界面
            self?.nameTextField.text = nil
            self?.pwdTextField.text = nil
            self?.repeatPwdTextField.text = nil

            self?.pwdTextField.becomeFirstResponder()
            self?.nameTextField.becomeFirstResponder()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
                let loginVc = LoginViewController()
                loginVc.title = "请登录"
                self?.navigationController?.pushViewController(loginVc, animated: true)
            })

        }
       
        alterVc.addAction(action)
        
        present(alterVc, animated: true, completion: nil)
    }
}

