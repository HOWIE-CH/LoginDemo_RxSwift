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
    
    var searchText = Variable<String>("")

    lazy var herosArray = { () -> [HerosItem] in
        guard let filePath = Bundle.main.path(forResource: "heros.plist", ofType: nil) else {
            return [HerosItem]()
        }
        
        guard let allArray = NSArray(contentsOfFile: filePath) as? [[String: AnyObject]] else {
            return [HerosItem]()
        }
        
        let tmpArray = NSMutableArray()
//        var tmp = [HerosItem]()
        for  dict in allArray {
            let hero = HerosItem(dict: dict)
//            tmp += hero
//            tmp.append(hero);   //这里不能用这个方法
            tmpArray.add(hero)
        }
        let array: NSArray = tmpArray
        return array as! [HerosItem]

    }()
    
    
    
    func getSearchResult() -> Observable<[SectionModel<String, HerosItem>]> {
        
        let result: Observable<[SectionModel<String, HerosItem>]> = searchText.asObservable()
            .flatMapLatest{ keyWord -> Observable<[SectionModel<String, HerosItem>]> in
                
                
                print(#file, #line, #function, ":++++++++++")
                
                // 默认搜索字为空时候加载所有数据
                if keyWord.characters.count == 0 {
                    let section = SectionModel(model: "", items: self.herosArray)
                    return Observable.just([section])
                }
                // 根据关键字搜索
                var resultArray = [HerosItem]()
                
                for item in self.herosArray {
                    if item.name.contains(keyWord) {
                        resultArray.append(item)
                    }
                }
                
                let section = SectionModel(model: "", items: resultArray)
                return Observable.just([section])
            }
            .shareReplay(1)
        
        return result
        
    }
    
   }

