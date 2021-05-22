//
//  ViewController.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/03/29.
//

import UIKit
import Photos
import FirebaseAuth
import EMAlertController

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, DoneSendProfileDelegate {
  
  
  var sendDB = SendDB()
  var loading = Loading()
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textView: PlaceHolderTextView!
  @IBOutlet weak var imageView: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    imageView.isUserInteractionEnabled = true
    imageView.layer.cornerRadius = 10.0
    imageView.image = UIImage(named: "not_image")
    textField.layer.cornerRadius = 3.0
    textField.layer.borderWidth = 2.0
    textField.layer.borderColor = UIColor.gray.cgColor
    textField.delegate = self
    textView.backgroundColor = .white
    textView.placeHolder = "自身の興味のある言語や分野を入力してください"
    textView.layer.cornerRadius = 4.0
    textView.layer.borderColor = UIColor.gray.cgColor
    textView.layer.borderWidth = 2.0
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    checkCamera()
  }
  
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= keyboardSize.height
      } else {
        let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
        self.view.frame.origin.y -= suggestionHeight
      }
    }
  }
  
  @objc func keyboardWillHide() {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
  
  @IBAction func register(_ sender: Any) {
    if textView.text.isEmpty == true || textField.text?.isEmpty == true || imageView.image == UIImage(named: "not_image") {
      nilAlert()
    } else {
      createUser()
      sendDB = SendDB()
      sendDB.doneSendProfileDelegate = self
      sendDB.sendProfile(userName: textField.text!, imageData: (imageView.image?.jpegData(compressionQuality: 0.5))!, profileText: textView.text!)
    }
  }
  
  @IBAction func tapImage(_ sender: Any) {
    showAlert()
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    textField.resignFirstResponder()
    textView.resignFirstResponder()
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }

  func daneSendProfileDelegate(sendCheck: Int) {
    if sendCheck == 1 {
      //画面遷移
        let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarController
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
  }


  func nilAlert() {
    let alert = EMAlertController(title: "未入力項目があります", message: "画像・名前・コメントに未入力の箇所があります")
    let close = EMAlertAction(title: "閉じる", style: .cancel)
    alert.cornerRadius = 10.0
    alert.addAction(close)
    present(alert, animated: true, completion: nil)
  }
  
  func createUser() {
    Auth.auth().signInAnonymously { (result, error) in
      let user = result?.user
      print(user.debugDescription)
      
      //アプリ内にtextを保存する
      UserDefaults.standard.set(self.textField.text, forKey: "userName")
    }
  }
  
  func checkCamera(){ // カメラ・アルバムの使用許可を促す
    PHPhotoLibrary.requestAuthorization { (status) -> Void in
      switch(status){
      case .authorized:
          print("Authorized")
          
      case .denied:
          print("Denied")
          
      case .notDetermined:
          print("NotDetermined")
          
      case .restricted:
          print("Restricted")
      case .limited:
          print("limited")
      @unknown default: break
          
      }
    }
  }
  
  func showAlert(){
    let alert: UIAlertController = UIAlertController(title: "選択してください。", message: "カメラアルバムどちらにしますか？", preferredStyle:  .alert)

    // カメラ
    let cameraAction: UIAlertAction = UIAlertAction(title: "カメラ", style: .default, handler:{
        (action: UIAlertAction!) -> Void in
        
        self.createImagePicker(sourceType: .camera)
    })
    // アルバム
    let albumAction: UIAlertAction = UIAlertAction(title: "アルバム", style: .default, handler:{
        (action: UIAlertAction!) -> Void in
        self.createImagePicker(sourceType: .photoLibrary)

    })
    
    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel)

    // UIAlertControllerに追加
    alert.addAction(albumAction)
    alert.addAction(cameraAction)
    alert.addAction(cancelAction)

    present(alert, animated: true, completion: nil)
  }

  func createImagePicker(sourceType:UIImagePickerController.SourceType){
    // インスタンスの作成
    let cameraPicker = UIImagePickerController()
    cameraPicker.sourceType = sourceType
    cameraPicker.delegate = self
    cameraPicker.allowsEditing = true
    self.present(cameraPicker, animated: true, completion: nil)
  }
      
  // 撮影をキャンセルした時に呼ばれる
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true, completion: nil)
  }
      
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[.editedImage] as? UIImage
    {
        imageView.image = pickedImage
        //閉じる
        picker.dismiss(animated: true, completion: nil)
    }
  }


}
