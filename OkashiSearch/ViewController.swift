//
//  ViewController.swift
//  OkashiSearch
//
//  Created by 曽和寛貴 on 2018/11/16.
//  Copyright © 2018 曽和寛貴. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searBarのdelegaten通知先を設定
        searchText.delegate = self
        
        searchText.placeholder = "お菓子の名前を入力してください！"
    }

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
//    検索ボタンをクリックした時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        キーボードを閉じる
        view.endEditing(true)
        
        if let searchword = searchBar.text {
//            デバッグエリアに入力文字を出力
            print(searchword)
        }
    }
}

