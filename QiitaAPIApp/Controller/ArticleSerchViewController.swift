//
//  ArticleSerchViewController.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/03/31.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import EMAlertController

class ArticleSerchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate, DoneCatchDataProtocol {


  var userName = String()
  var userID = String()
  var db = Firestore.firestore()
  var dataStructsArray = [DataStructs]()
  var loading = Loading()
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var serchTextField: UITextField!
  

  override func viewDidLoad() {
        super.viewDidLoad()

    serchTextField.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    
    if UserDefaults.standard.object(forKey: "userName") != nil {
      userName = UserDefaults.standard.object(forKey: "userName") as! String
    }
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
    
    
  }

  @IBAction func serchTap(_ sender: Any) {
    serch()
    serchTextField.endEditing(true)
    loading.startAnimation(view: self.view)
  }
  
  @objc func favButtonTap(_ sender:UIButton) {
    print(sender.tag)
    likeTap()
    let sendDB = SendDB(userID: Auth.auth().currentUser!.uid, userName: userName, urlString: dataStructsArray[sender.tag].url, title: dataStructsArray[sender.tag].title, updatedAt: dataStructsArray[sender.tag].updatedAt, likesCount: dataStructsArray[sender.tag].likesCount, articleID: UUID().uuidString)
    sendDB.sendData(userName: userName, userID: String(Auth.auth().currentUser!.uid))
  }
  
  func serch() {
    let urlString = "https://qiita.com/api/v2/items?page=1&per_page=50&query=\(serchTextField.text!) created:>2018-01-01 stocks:>5"
    let searchModel = SearchAndLoadModel(urlString: urlString)
    searchModel.doneCatchDataProtocol = self
    searchModel.serch()
  }
  
  func likeTap() {
    let alert = EMAlertController(title: "お気に入り登録完了", message: "お気に入りに追加しました！")
    let close = EMAlertAction(title: "閉じる", style: .cancel)
    alert.cornerRadius = 10.0
    alert.addAction(close)
    present(alert, animated: true, completion: nil)
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


  func doneCatchData(arry: [DataStructs]) {
    print(arry.debugDescription)
    dataStructsArray = arry //渡ってきた配列を自身の配列に追加
    tableView.reloadData()
    DispatchQueue.main.async {
      self.loading.stopAnimation()
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    serchTextField.resignFirstResponder()
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
