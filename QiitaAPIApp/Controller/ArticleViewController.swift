//
//  ArticleViewController.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/04/01.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {


  var urlString = String()
  var webView: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    let navigationBarHeight = navigationController?.navigationBar.frame.size.height
    // WKWebViewを生成
    webView = WKWebView(frame: CGRect(x: 0, y: navigationBarHeight! + statusBarHeight, width: view.frame.width, height: view.frame.height))
    // WKWebViewをViewControllerのviewに追加する
    view.addSubview(webView)
    // リクエストを生成
    let request = URLRequest(url: URL(string: urlString)!)
    // リクエストをロードする
    webView.load(request)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
  }
  
  
  
  
}
