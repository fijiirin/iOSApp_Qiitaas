//
//  Loading.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/04/13.
//

import Foundation
import Lottie

class Loading {
  
  let animationView = AnimationView()
  
  func startAnimation(view:UIView) {
    let animation = Animation.named("loading")
    animationView.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: view.frame.size.height/1.5)
    animationView.animation = animation
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.play()
    view.addSubview(animationView)
  }
  
  func stopAnimation() {
    animationView.removeFromSuperview()
  }


}
