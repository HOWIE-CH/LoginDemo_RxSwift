//
//  HomeViewController.swift
//  loginRx
//
//  Created by HOWIE-CH on 17/2/28.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class HomeViewController: UIViewController {

    
    fileprivate lazy var tableView = { () -> UITableView in 
        let tabelView = UITableView(frame: UIScreen.main.bounds,
                                    style: .plain)
        return tabelView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        
        
        
    }


}
