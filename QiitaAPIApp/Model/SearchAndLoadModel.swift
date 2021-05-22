//
//  SerchAndLoadModel.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/03/31.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SwiftyJSON
import Alamofire

protocol DoneCatchDataProtocol {
  func doneCatchData(arry:[DataStructs])
}
protocol DoneLoadMyListDataProtocol {
  func doneLoadMyListData(array:[FavStructs])
}
protocol DoneLoadUserNameProtocol {
  func doneloadUsername(array:[String])
}
protocol DoneLoadOtherListDataProtocol {
  func doneLoadAtherListData(array:[DataStructs])
}
protocol DoneLoadProfileProtocol {
  func doneLoadProfile(userName:String, profileText:String, imageURLString:String)
}

class SearchAndLoadModel {


  var db = Firestore.firestore()
  
  var urlString = String()
  var resultPerPage = Int()
  var dataStructsArray:[DataStructs] = []
  var favStructsArray:[FavStructs] = []
  var userNameArray:[String] = []
  
  var doneCatchDataProtocol:DoneCatchDataProtocol?
  var doneLoadMyListDataprotocol:DoneLoadMyListDataProtocol?
  var doneLoadUserNameProtocol:DoneLoadUserNameProtocol?
  var doneLoadOtherListDataProtocol:DoneLoadOtherListDataProtocol?
  var doneLoadProfileProtocol:DoneLoadProfileProtocol?
  

  init() {
    
  }
  init(urlString:String) {
    self.urlString = urlString
  }


  //記事検索
  func serch() {
    let encordUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    AF.request(encordUrlString!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
      switch response.result {
      case .success:
        do {
          let json:JSON = try JSON(data: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
          let totalCount = json[].count
          if totalCount < 50 {
            self.resultPerPage = totalCount
          } else {
            self.resultPerPage = totalCount
          }
          print(self.resultPerPage)
          for i in 0...self.resultPerPage - 1 {
            if let title = json[i]["title"].string, let url = json[i]["url"].string, let likesCount = json[i]["likes_count"].int, let updatedAt = json[i]["updated_at"].string {
              let dataStructs = DataStructs(title: title, url: url, likesCount: String(likesCount), updatedAt: updatedAt)
              self.dataStructsArray.append(dataStructs) //配列に追加
            } else {
              print("JSONの取得がうまくいきませんでした。空の可能性もあります。")
            }
          }
          //値を渡す(プロトコルを用いて配列をコントローラーに渡す)
          self.doneCatchDataProtocol?.doneCatchData(arry: self.dataStructsArray)
        } catch {
          print("JSONが取得できませんでした")
        }
      
      case .failure(_): break
      }
    }
  }


  //ユーザー名ごとのお気に入り記事
  func loadMyList(userName:String) {
    db.collection("contents").document(userName).collection("collection").order(by: "postDate").addSnapshotListener { (snapShot, error) in
      if error != nil {
        print(error.debugDescription)
        return
      }
      self.favStructsArray = []
      if let snapShotDoc = snapShot?.documents {
        for doc in snapShotDoc {
          let data = doc.data()
          if let title = data["title"] as? String, let url = data["urlString"] as? String, let likesCount = data["likesCount"] as? String, let updatedAt = data["updatedAt"] as? String, let articleID = data["articleID"] as? String {
            let dataStructs = FavStructs(title: title, url: url, likesCount: likesCount, updatedAt: updatedAt, articleID: articleID)
            self.favStructsArray.append(dataStructs)
          } else {
            print("if let が正しくない")
          }
        }
        self.doneLoadMyListDataprotocol?.doneLoadMyListData(array: self.favStructsArray)
      }
    }
  }


  //他の人のお気に入り
  func loadOtherArticleList(userName:String) {
    db.collection("contents").document(userName).collection("collection").order(by: "postDate").addSnapshotListener { (snapShot, error) in
      self.dataStructsArray = []
      if error != nil {
        print(error.debugDescription)
        return
      }
      if let snapShotDoc = snapShot?.documents {
        for doc in snapShotDoc {
          let data = doc.data()
          
          if let title = data["title"] as? String, let url = data["urlString"] as? String, let likesCount = data["likesCount"] as? String, let updatedAt = data["updatedAt"] as? String{
            let dataStructs = DataStructs(title: title, url: url, likesCount: likesCount, updatedAt: updatedAt)
            self.dataStructsArray.append(dataStructs)
          } else {
            print("if let が正しくない")
          }
        }
        self.doneLoadOtherListDataProtocol?.doneLoadAtherListData(array: self.dataStructsArray)
      }
    }
  }


  //ユーザー名を受信する
  func loadOtherList() {
    db.collection("users").addSnapshotListener { (snapShot, error) in
      if let snapShotDoc = snapShot?.documents {
        for doc in snapShotDoc {
          let data = doc.data()
          if let userName = data["userName"] as? String {
            self.userNameArray.append(userName)
          }
        }
        self.doneLoadUserNameProtocol?.doneloadUsername(array: self.userNameArray)
      }
    }
  }


  //プロフィール情報を受信する
  func loadProfile(userName:String) {
    db.collection("profile").document(userName).addSnapshotListener { (snapShot, error) in
      if error != nil {
        print(error.debugDescription)
        return
      }
      let data = snapShot?.data()
      if let userName = data!["userName"] as? String, let profileText = data!["profileText"] as? String, let imageURLString = data!["imageURLString"] as? String {
        self.doneLoadProfileProtocol?.doneLoadProfile(userName: userName, profileText: profileText, imageURLString: imageURLString)
        print("プロフ受信完了")
      }
    }
  }


}
