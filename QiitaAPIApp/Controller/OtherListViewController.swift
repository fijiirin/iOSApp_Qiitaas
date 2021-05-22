//
//  OtherListViewController.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/04/03.
//

import UIKit

class OtherListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DoneLoadUserNameProtocol {


  var userNameArray = [String]()
  var searchAndLoad = SearchAndLoadModel()
  
  var searchAndLoadModel = SearchAndLoadModel()
  
  @IBOutlet weak var tableView: UITableView!


  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    searchAndLoadModel.doneLoadUserNameProtocol = self
    searchAndLoadModel.loadOtherList()
    tableView.register(UINib(nibName: "UserNameCell", bundle: nil), forCellReuseIdentifier: "UserNameCell")
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
    tableView.reloadData()
  }


  func doneloadUsername(array: [String]) {
    userNameArray = array
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userNameArray.count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let otherArticleVC = storyboard?.instantiateViewController(identifier: "otherArticleVC") as! OtherArticleViewController
    otherArticleVC.userName = userNameArray[indexPath.row]
    navigationController?.pushViewController(otherArticleVC, animated: true)
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserNameCell", for: indexPath) as! UserNameCell
    cell.userNameLabel.text = userNameArray[indexPath.row]
    
    return cell
  }


}
