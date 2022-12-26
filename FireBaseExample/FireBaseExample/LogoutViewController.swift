//
//  LogoutViewController.swift
//  FireBaseExample
//
//  Created by ashutosh deshpande on 10/12/2022.
//

import UIKit
import FirebaseAuth
import Toast_Swift
import AVFoundation
import AVFAudio
class LogoutViewController: UIViewController {
    var lapCount = 0
    var timer = Timer()
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var eMailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //User Default Database File
        eMailLabel.text = DataBaseFile.shared.fetchEMail()
        // Do any additional setup after loading the view.
    }
   
    
    @objc func nextScreen(){
        lapCount = lapCount + 1
        if lapCount > 1{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! NavigationViewController
            let window = UIApplication.shared.windows[0] as UIWindow
            UIView.transition(from: (window.rootViewController?.view)!, to: secondViewController.view, duration: 0.65, options: .transitionCrossDissolve) { bool in
                window.rootViewController = secondViewController
            }
            timer.invalidate()

        }else {
          
                
                 guard let mp3File = Bundle.main.url(forResource: "ByeBye", withExtension: "mp3") else { return  }
                 do {
                     audioPlayer = try AVAudioPlayer(contentsOf: mp3File)
                     audioPlayer.play()
                 }catch let error {
                     self.view.makeToast("\(error.localizedDescription)", duration: 3.0, position: .bottom)
                 }
               
             
                
           
        }
    }
    
    @IBAction func officeLocation(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapKitViewController")as! MapKitViewController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
       
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        //Firebase
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(nextScreen), userInfo: nil, repeats: true)
       
        let firebaseAuth = Auth.auth()
        do{
        try firebaseAuth.signOut()
        }catch let error {
            self.view.makeToast("\(error.localizedDescription)", duration: 3.0, position: .bottom)
        }
        self.view.makeToast("Logout Successfully", duration: 3.0, position: .bottom)
        
    }

}
