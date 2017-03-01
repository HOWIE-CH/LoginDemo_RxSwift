//
//  HomeViewModel.swift
//  loginRx
//
//  Created by HOWIE-CH on 17/2/28.
//  Copyright © 2017年 com.bluestar. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HomeViewModel {
    
    lazy var herosArray = { () -> [HerosItem] in
        
        guard let filePath = Bundle.main.path(forResource: "heros.plist", ofType: nil) else {
            return [HerosItem]()
        }
        
        guard let allArray = NSArray(contentsOfFile: filePath) as? [[String: AnyObject]] else {
            return [HerosItem]()
        }
        
        var herosArray = [HerosItem]()
        for  dict in allArray {
            var hero = HerosItem(dict: dict)
            (herosArray as NSArray).adding(hero)
        }
        return herosArray
    }()
    var searchText = Variable<String>("")
    var searchResult: Observable<[SectionModel<String, HerosItem>]>
    
    init() {
        searchResult = searchText.asObservable()
            .map { (keyWord) -> Observable<[SectionModel<String, HerosItem>]> in
                
                
                
                
                return
                
            }
        
    }
    
}

