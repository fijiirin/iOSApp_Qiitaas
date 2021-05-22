//
//  MyListViewController.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/04/03.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,DoneLoadMyListDataProtocol {


  var userName = String()
  var dataStructsArray = [FavStructs]()
  var searchAndLoad = SearchAndLoadModel()
  
  @IBOutlet weak var tableView: UITableView!


  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    
    if UserDefaults.standard.object(forKey: "userName") != nil {
      userName = UserDefaults.standard.object(forKey: "userName") as! String
    }
    searchAndLoad.doneLoadMyListDataprotocol = self
    searchAndLoad.loadMyList(userName: userName)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }


  @objc func notFavButtonTap(_ sender:UIButton) {
    print(sender.tag)
    let sendDB = SendDB(articleID: dataStructsArray[sender.tag].articleID)
    sendDB.deleteData(userName: userName)
    tableView.reloadData()
  }
  
  func parse(dateString:String) -> NSDate {
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssxxx"
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
    let d = formatter.date(from: dateString)
    return NSDate(timeInterval: 0, since: d!)
  }
  
  func dateCastString(date: NSDate) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    let dateString: String = dateFormatter.string(from: date as Date)
    return dateString
  }


  func doneLoadMyListData(array: [FavStructs]) {
    print(array.debugDescription)
    dataStructsArray = array
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataStructsArray.count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let articleVC = storyboard?.instantiateViewController(identifier: "articleVC") as! ArticleViewController
    articleVC.urlString = dataStructsArray[indexPath.row].url
    navigationController?.pushViewController(articleVC, animated: true)
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
    cell.articleTitleLabel.text = dataStructsArray[indexPath.row].title
    let dateString = dateCastString(date: parse(dateString: dataStructsArray[indexPath.row].updatedAt))
    cell.dateLabel.text = String(dateString.prefix(10))
    cell.articleTitleLabel.text = dataStructsArray[indexPath.row].title
    cell.likeCountLabel.text = dataStructsArray[indexPath.row].likesCount
    //ブックマークボタン
    let favButtonNot = UIButton(frame: CGRect(x: 320, y: 15, width: 40, height: 40))
    favButtonNot.setImage(UIImage(named: "favButtonNot"), for: .normal)
    favButtonNot.addTarget(self, action: #selector(notFavButtonTap(_:)), for: .touchUpInside)
    favButtonNot.tag = indexPath.row
    cell.contentView.addSubview(favButtonNot)
    
    return cell
  }


}
