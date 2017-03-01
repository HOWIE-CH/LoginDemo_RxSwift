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
        tabelView.rowHeight = 66
        return tabelView
    }()
    
    lazy var searchView = { () -> UISearchBar in
        let searchView = UISearchBar(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 44))
        return searchView
    }()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, HerosItem>>()

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchView)
        view.addSubview(tableView)
        
        
        
        dataSource.configureCell = { (_, tableView, indexPath, item) in
            var cell = tableView.dequeueReusableCell(withIdentifier: "herosCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "herosCell")
            }
            cell!.imageView?.image = UIImage(named: item.icon)
            cell!.textLabel?.text = item.name
            cell!.detailTextLabel?.text = item.intro
            return cell!
        }
        
        
        let homeViewMode = HomeViewModel()
        
        
        
        searchView.rx.text.orEmpty
            .bindTo(homeViewMode.searchText)
            .addDisposableTo(disposeBag)
        
        
        homeViewMode.getSearchResult()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected
            .map { [weak self] indexPath in
                return (indexPath, self?.dataSource[indexPath])
            }
            .subscribe(onNext: {(indexPath, item) in
                self.showAlter(item: item)
            })
            .addDisposableTo(disposeBag)
    }


}

extension HomeViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
extension HomeViewController {
    
    func showAlter(item: HerosItem?) {
        let alterVc = UIAlertController(title: "Demo结束了！", message: item?.intro ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "好吧", style: .default, handler: nil)
        alterVc.addAction(action)
        present(alterVc, animated: true, completion: nil)
    }
    
    
}

