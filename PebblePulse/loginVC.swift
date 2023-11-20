//
//  loginVC.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/17/23.
//

import UIKit
import Lottie
import FirebaseAuth

class loginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var animViewLogin: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.isEnabled = false
        emailField.delegate = self
        passwordField.delegate = self
        
        signInButton.isEnabled = false
        
        emailField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        animViewLogin.contentMode = .scaleAspectFit
        animViewLogin.loopMode = .loop
        animViewLogin.animationSpeed = 0.8
        animViewLogin.play()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            print("Email or Password cannot be empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error in signing in: \(error)")
                return
            }
            print("User signed in successfully")
            
            strongSelf.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isEmailEmpty = emailField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordField.text?.isEmpty ?? true
        signInButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
