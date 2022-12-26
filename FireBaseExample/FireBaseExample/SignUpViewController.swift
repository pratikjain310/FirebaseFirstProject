//
//  SignUpViewController.swift
//  FireBaseExample
//
//  Created by ashutosh deshpande on 06/12/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Toast_Swift
class SignUpViewController: UIViewController {
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButton(_ sender: Any) {
      
        if usernameTextField.text?.isEmpty == true &&  passwordTextField.text?.isEmpty == true && confirmPasswordTextField.text?.isEmpty == true{
            self.view.makeToast("Please enter all the Details", duration: 3.0, position: .bottom)
            return
        }
        
        if !isValidUserName(testStr: usernameTextField.text ?? ""){
            self.view.makeToast("Please enter valid Email", duration: 3.0, position: .bottom)
            return
        }
        
        if passwordTextField.text != confirmPasswordTextField.text {
            self.view.makeToast("Password And Confirm Password Must be Same", duration: 3.0, position: .bottom)
            return
        }
       
      
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { [unowned self] authResult, error in
            if error == nil {
                self.view.makeToast("User Created", duration: 3.0, position: .bottom)
                //User Default Database File
                DataBaseFile.shared.saveDetails(uId: (authResult?.user.uid)!, eMail: (authResult?.user.email)!)
                // Firebase
                Database.database().reference().child("User").child((authResult?.user.uid)!).updateChildValues(["uId": authResult?.user.uid, "email": authResult?.user.email])
                
                let firebaseAuth = Auth.auth()
                try? firebaseAuth.signOut()
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as! NavigationViewController
                let window = UIApplication.shared.windows[0] as UIWindow
                UIView.transition(from: (window.rootViewController?.view)!, to: secondViewController.view, duration: 0.05, options: .transitionCrossDissolve) { bool in
                    window.rootViewController = secondViewController
                }
               
                
            }else {
                self.view.makeToast("\(error!.localizedDescription)", duration: 3.0, position: .bottom)
            }
        }
        //use database to save login details in firebase
       
        
       
    }
    func isValidUserName(testStr: String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
