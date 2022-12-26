//
//  SplashScreenViewController.swift
//  FireBaseExample
//
//  Created by ashutosh deshpande on 22/12/2022.
//

import UIKit
import AVFoundation
class SplashScreenViewController: UIViewController {
    var lapCount = 0
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let mp4File = Bundle.main.url(forResource: "Welcome - animation", withExtension: "mp4") else { return  }
        let player = AVPlayer(url: mp4File)
        let layer = AVPlayerLayer(player: player)
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
        player.play()
        self.view.backgroundColor = .black
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(nextScreen), userInfo: nil, repeats: true)
        
    }
    
    @objc func nextScreen(){
        lapCount = lapCount + 1
        if lapCount > 6{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            let window = UIApplication.shared.windows[0] as UIWindow
            UIView.transition(from: (window.rootViewController?.view)!, to: secondViewController.view, duration: 0.65, options: .transitionCrossDissolve) { bool in
                window.rootViewController = secondViewController
            }
            timer.invalidate()

        }
    }


}
