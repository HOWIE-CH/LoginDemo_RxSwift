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
        let tabelView = UITableView(frame: CGRect(x: 0, y: 108, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 108),
                                    style: .plain)
        return tabelView
    }()
    
    lazy var searchView = { () -> UISearchBar in
        let searchView = UISearchBar(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 44))
        return searchView
    }()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, HerosItem>>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchView)
        view.addSubview(tableView)
        
        dataSource.configureCell = { (_, tableView, indexPath, item) in
            var cell = tableView.dequeueReusableCell(withIdentifier: "herosCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "herosCell")
            }
            return cell!
        }
        
        
        
        
        
        
        
        
    }


}
