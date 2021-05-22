//
//  SendDB.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/03/30.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

protocol DoneSendProfileDelegate {
  func daneSendProfileDelegate(sendCheck:Int)
}

class SendDB {
  
  var db = Firestore.firestore()
  
  var doneSendProfileDelegate:DoneSendProfileDelegate?
  
  var userName = String()
  var imageData = Data()
  var userID = String()
  var urlString = String()
  var title = String()
  var likesCount = String()
  var updatedAt = String()
  var articleID = String()


  init() {
    
  }
  init(articleID:String) {
    self.articleID = articleID
  }
  init(userID:String, userName:String, urlString:String, title:String, updatedAt:String, likesCount:String, articleID:String) {
    self.userID = userID
    self.userName = userName
    self.urlString = urlString
    self.title = title
    self.updatedAt = updatedAt
    self.likesCount = likesCount
    self.articleID = articleID
  }


  //ユーザーのお気に入り記事のデータとユーザー情報を送信
  func sendData(userName:String, userID:String) {
    db.collection("contents").document(userName).collection("collection").document(articleID).setData(
      ["userID":self.userID as Any, "userName":self.userName as Any, "urlString":self.urlString as Any, "title":self.title as Any, "likesCount":self.likesCount, "updatedAt":self.updatedAt as Any, "articleID": self.articleID as Any, "postDate":Date().timeIntervalSince1970])
    
    self.db.collection("users").document(userID).setData(["userName":self.userName])
  }
  
  //お気に入りの削除
  func deleteData(userName:String) {
    db.collection("contents").document(userName).collection("collection").document(articleID).delete()
  }
  
  //プロフィールの送信
  func sendProfile(userName:String, imageData:Data, profileText:String) {
    let imageRef = Storage.storage().reference().child("ProfileImageFolder").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
    
    imageRef.putData(imageData, metadata: nil) { (metaData, error) in
      
      if error != nil {
        print(error.debugDescription)
        return
      }
      
      imageRef.downloadURL { (url, error) in
        if error != nil {
          print(error.debugDescription)
          return
        }
        
        self.db.collection("profile").document(userName).setData(
          ["userName":userName as Any, "imageURLString":url?.absoluteString as Any, "profileText":profileText])
      }
      self.doneSendProfileDelegate?.daneSendProfileDelegate(sendCheck: 1)
    }
  }


  


}
