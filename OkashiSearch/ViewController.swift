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
            
//            入力されていたら、お菓子を検索
            searchOkashi(keyword: searchword)
        }
    }
    
//    JSONのitem内のデータ構造
    struct ItemJson: Codable {
        
//        お菓子の名称／
        let name: String?
        
//        メーカー
        let maker: String?
        
//        掲載URL
        let url: URL?
        
//        画像URL
        let image: URL?
    }
    
//    JSONのデータ構造
    struct ResulttJson: Codable {
        
//        複数要素
        let item:[ItemJson]
    }
    
//    第一引数：keyword 検索したいキーワード
    func searchOkashi(keyword: String) {
        
//        お菓子の検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
//        リクエストURLの組み立て
        guard let req_url = URL(string: "http://www.sysbirb.jp/toriko/aip/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            return
        }
        print(req_url)
    }
}

