//
//  SceneDelegate.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/03/29.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //ログインしている時と、そうでない時で最初に遷移する画面を変更する
        if Auth.auth().currentUser?.uid != nil { //もし現在のユーザーのuidがFirebaseにあれば
          //つぶやき画面に遷移させる
          let window = UIWindow(windowScene: scene as! UIWindowScene) //windowを定義
          self.window = window  //自身のwindowに代入
          window.makeKeyAndVisible() //windowを表示させるメソッド

          let storyBoard = UIStoryboard(name: "Main", bundle: nil) //storyBoardをインスタンス化させる
          let tweetViewController = storyBoard.instantiateViewController(identifier: "tabBarVC")
          let navigationVC = UINavigationController(rootViewController: tweetViewController) //navigationVCの初期画面にtweetVCを設定する
          window.rootViewController = navigationVC //windowの初期画面に設定したnavigationVCを代入する
        } else {
          //ログイン画面へ遷移させる
          let window = UIWindow(windowScene: scene as! UIWindowScene) //windowを定義
          self.window = window  //自身のwindowに代入
          window.makeKeyAndVisible() //windowを表示させるメソッド

          let storyBoard = UIStoryboard(name: "Main", bundle: nil) //storyBoardをインスタンス化させる
          let tweetViewController = storyBoard.instantiateViewController(identifier: "loginVC")
          let navigationVC = UINavigationController(rootViewController: tweetViewController) //navigationVCの初期画面にtweetVCを設定する
          window.rootViewController = navigationVC //windowの初期画面に設定したnavigationVCを代入する
        }

  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }


}

