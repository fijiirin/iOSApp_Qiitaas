//
//  OtherArticleViewController.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/04/04.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import EMAlertController

class OtherArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DoneLoadOtherListDataProtocol, DoneLoadProfileProtocol {


  var myUserName = String()
  var userName = String()
  var dataStructsArray = [DataStructs]()
  var searchAndLoad = SearchAndLoadModel()
  var db = Firestore.firestore()

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var profileImageView: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    searchAndLoad.doneLoadOtherListDataProtocol = self
    searchAndLoad.doneLoadProfileProtocol = self
    searchAndLoad.loadOtherArticleList(userName: userName)
    titleLabel.text = "\(userName)さんのリスト"
    if UserDefaults.standard.object(forKey: "userName") != nil {
      myUserName = UserDefaults.standard.object(forKey: "userName") as! String
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
  }


  @objc func favButtonTap(_ sender:UIButton) {
    print(sender.tag)
    likeTap()
    let sendDB = SendDB(userID: Auth.auth().currentUser!.uid, userName: myUserName, urlString: dataStructsArray[sender.tag].url, title: dataStructsArray[sender.tag].title, updatedAt: dataStructsArray[sender.tag].updatedAt, likesCount: dataStructsArray[sender.tag].likesCount, articleID: UUID().uuidString)
    sendDB.sendData(userName: myUserName, userID: String(Auth.auth().currentUser!.uid))
  }
  @IBAction func showProfile(_ sender: Any) {
    print("プロフボタン押したよ！")
    searchAndLoad.loadProfile(userName: userName) //モデルの関数を実行(プロトコルから値を受け取る)
  }
  func likeTap() {
    let alert = EMAlertController(title: "お気に入り登録完了", message: "お気に入りに追加しました！")
    let close = EMAlertAction(title: "閉じる", style: .cancel)
    alert.cornerRadius = 10.0
    alert.addAction(close)
    present(alert, animated: true, completion: nil)
  }
  func showAlert(userName:String, profileText:String, imageURLString:String) {
    let alert = EMAlertController(title: userName, message: profileText)
    let close = EMAlertAction(title: "閉じる", style: .cancel)
    alert.cornerRadius = 10.0
    alert.iconImage = getImageURL(url: imageURLString)
    alert.addAction(close)
    present(alert, animated: true, completion: nil)
  }
  func getImageURL(url:String) -> UIImage {
    let url = URL(string: url)
    do {
      let data = try Data(contentsOf: url!)
      return UIImage(data: data)!
    } catch {
      print("imageURLStringをUIImage型に変換できませんでした。")
    }
    return UIImage()
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


  func doneLoadAtherListData(array: [DataStructs]) {
    dataStructsArray = array
    tableView.reloadData()
    print("他の人のデータを受信できました。")
  }

  func doneLoadProfile(userName: String, profileText: String, imageURLString: String) {
    showAlert(userName: userName, profileText: profileText, imageURLString: imageURLString)
    print("アラートおk")
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
    let favButton = UIButton(frame: CGRect(x: 320, y: 15, width: 40, height: 40))
    favButton.setImage(UIImage(named: "favButton"), for: .normal)
    favButton.addTarget(self, action: #selector(favButtonTap(_:)), for: .touchUpInside)
    favButton.tag = indexPath.row
    cell.contentView.addSubview(favButton)
    
    return cell
  }


}
