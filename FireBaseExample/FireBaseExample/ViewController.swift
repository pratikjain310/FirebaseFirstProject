//
//  ViewController.swift
//  FireBaseExample
//
//  Created by ashutosh deshpande on 05/12/2022.
//

import UIKit
import FirebaseAuth
import Toast_Swift
class ViewController: UIViewController {
    var windows = UIWindow()
   
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        usernameTextField.text = ""
        passwordTextField.text = ""
        
        let user = Auth.auth().currentUser;
        if user != nil {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            let window = UIApplication.shared.windows[0] as UIWindow
            UIView.transition(from: (window.rootViewController?.view)!, to: secondViewController.view, duration: 0.65, options: .transitionCrossDissolve) { [unowned self] bool in
                window.rootViewController = secondViewController
            }
        }
    }
    
    func isValidUserName(testStr: String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func signInButton(_ sender: Any) {
       
        
        if usernameTextField.text?.isEmpty == true &&  passwordTextField.text?.isEmpty == true {
            self.view.makeToast("Please enter all the Details", duration: 3.0, position: .bottom)
            return
        }
        if !isValidUserName(testStr: usernameTextField.text ?? ""){
            self.view.makeToast("Please enter valid Email", duration: 3.0, position: .bottom)
            return
        }
       
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { [unowned self] result, error in
            if error == nil{
                if result?.user.email == usernameTextField.text{
                    self.view.makeToast("Login Successfully", duration: 3.0, position: .bottom)
                    //User Default Database File
                    DataBaseFile.shared.saveDetails(uId: (result?.user.uid)!, eMail: (result?.user.email)!)
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SplashScreenViewController") as! SplashScreenViewController
                    let window = UIApplication.shared.windows[0] as UIWindow
                    UIView.transition(from: (window.rootViewController?.view)!, to: secondViewController.view, duration: 0.65, options: .transitionCrossDissolve) { bool in
                        window.rootViewController = secondViewController
                    }
                }
            }else {
                self.view.makeToast("\(error!.localizedDescription)", duration: 3.0, position: .bottom)
            }
            
        }
        
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        if usernameTextField.text?.isEmpty == true{
            self.view.makeToast("Please enter Email ID", duration: 3.0, position: .bottom)
            return
        }
        if !isValidUserName(testStr: usernameTextField.text ?? ""){
            self.view.makeToast("Please enter valid Email ID", duration: 3.0, position: .bottom)
            return
        }
        Auth.auth().sendPasswordReset(withEmail: usernameTextField.text!) { [unowned self] error in
            if error == nil{
                self.view.makeToast("Password Reset Link Send to Mail ID", duration: 3.0, position: .bottom)
            }else {
                self.view.makeToast("\(error!.localizedDescription)", duration: 3.0, position: .bottom)
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
}

