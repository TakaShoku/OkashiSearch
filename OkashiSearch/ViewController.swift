//
//  ViewController.swift
//  OkashiSearch
//
//  Created by 曽和寛貴 on 2018/11/16.
//  Copyright © 2018 曽和寛貴. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searBarのdelegaten通知先を設定
        searchText.delegate = self
        
        searchText.placeholder = "お菓子の名前を入力してください！"
        
//        tableViewのdataSourceを設定
        tableView.dataSource = self
    }

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
//    お菓子のリスト（タプルの配列）
    var okashiList : [(name:String, maker:String, link:URL, image:URL)] = []
    
    
//    検索ボタンをクリックした時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        キーボードを閉じる
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
//            デバッグエリアに入力文字を出力
            print(searchWord)
            
//            入力されていたら、お菓子を検索
            searchOkashi(keyword: searchWord)
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
    struct ResultJson: Codable {
        
//        複数要素
        let item:[ItemJson]?
    }
    
//    第一引数：keyword 検索したいキーワード
    func searchOkashi(keyword: String) {
        
//        お菓子の検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
//        リクエストURLの組み立て
        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r")
            else {
                return
        }
        print(req_url)
        
//        リスクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        
//        データ転送を管理するためのセッションをさ生成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
//        リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data , response , error) in
            
//            セッションを修了
            session.finishTasksAndInvalidate()
            
//            エラーハンドリング
            do {
//                JSONDecoderのインスタンス取得
                let decoder = JSONDecoder()
//                受け取ったJSONデータをパース（解析）して格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                
//                お菓子の情報が取得できているか確認
                if let items = json.item {
                    
//                    お菓子リストの初期化
                    self.okashiList.removeAll()
//                    取得しているお菓子の数だけ処理
                    for item in items {
                        
//                        お菓子の名称、メーカーの名称、掲載URL、画像のURLをアンラップ
                        if let name = item.name, let maker = item.maker, let link = item.url, let image = item.image {
                            
//                            一つのお菓子をタプルでまとめて管理
                            let okashi = (name, maker, link, image)
                            
//                            お菓子の配列へ追加
                            self.okashiList.append(okashi)
                        }
                    }
//                    Table Viewを更新する
                    self.tableView.reloadData()
                    
                    if let okashidbg = self.okashiList.first {
                        print("----------------------------")
                        print("okashiList[0] = \(okashidbg)")
                    }
                }
                
            } catch {
//                エラー処理
                print("エラーが発生しました。")
            }
        })
//        ダウンロード開始
        task.resume()
    }
    
//    Cellの総数を返すdataSourceメソッド、必ず記述する必要がある
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        お菓子リストの総数
        return okashiList.count
    }
    
//    Cellに値を設定するdataSourceメソッド、必ず記述する必要がある
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        今回表示を行う。Cellオブジェクト（１行）を取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath)
//        お菓子のタイトル設定
        cell.textLabel?.text = okashiList[indexPath.row].name
//        お菓子の画像取得
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].image) {
//            正常に取得できた場合は、UIImageで画像オブジェクトを生成して、Cellんにお菓子画像を設定
            cell.imageView?.image = UIImage(data: imageData)
        }
//        設定済みのCellオブジェクトを画像に反映
        return cell
    }
    
}

