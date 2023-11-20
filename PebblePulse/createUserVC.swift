//
//  createUserVC.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/17/23.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import CryptoKit
import LocalAuthentication
import AppTrackingTransparency
import Lottie





class createUserVC: UIViewController, UITextFieldDelegate {
    weak var delegate: CreateUserVCDelegate?

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordStrengthIndicator: UIProgressView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var termsCheckbox: UIButton!

    @IBOutlet weak var animViewSignUp: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.textColor = .black
        passwordField.textColor = .black
        animViewSignUp.contentMode = .scaleAspectFit
        animViewSignUp.loopMode = .loop
        animViewSignUp.animationSpeed = 0.8
        animViewSignUp.play()
        setupTextField()
        registerButton.isEnabled = false
        termsCheckbox.isSelected = false
        passwordStrengthIndicator.setProgress(0, animated: false)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(createUserVC.dismissKeyboard))
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    
    func setupTextField() {
        emailField.delegate = self
        passwordField.delegate = self
        emailField.keyboardType = .emailAddress
        emailField.autocorrectionType = .no
        passwordField.addTarget(self, action: #selector(passwordChanged(_:)), for: .editingChanged)
        passwordField.textContentType = .oneTimeCode
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            self.passwordField.becomeFirstResponder()
        case passwordField:
            return true
//            self.createUserActual()
        default:
            self.passwordField.becomeFirstResponder()
        }
        
        return false
    }
  
    
    @objc func passwordChanged(_ textField: UITextField) {
        guard let password = textField.text else { return }
        let strength = checkPasswordStrength(password)
        passwordStrengthIndicator.setProgress(strength, animated: true)
        validateInputs()
    }
    
    func checkPasswordStrength(_ password: String) -> Float {
        var strength: Float = 0.0
        if password.count >= 8 { strength += 0.25 }
        
        if password.rangeOfCharacter(from: .decimalDigits) != nil { strength += 0.35}
        
        let symbols = CharacterSet.symbols.union(.punctuationCharacters)
        if password.rangeOfCharacter(from: symbols) != nil { strength += 0.40 }
        updateStrengthIndicatorColor(strength)

        return strength
    }

    func updateStrengthIndicatorColor(_ strength: Float) {
        let color: UIColor
        switch strength {
        case 0..<0.3: color = .red
        case 0.3..<0.6: color = .orange
        case 0.6...1: color = .blue
        default: color = .red
        }
        passwordStrengthIndicator.progressTintColor = color
    }

    func validateInputs() {
        let emailIsValid = isValidEmail(emailField.text)
        let passwordIsValid = checkPasswordStrength(passwordField.text ?? "") >= 1.0
        let termsAgreed = termsCheckbox.isSelected

        
        registerButton.isEnabled = emailIsValid && passwordIsValid && termsAgreed

    }

    
    func isValidEmail(_ email: String?) -> Bool {
        guard email != nil else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    
    @IBAction func termsCheckboxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.setImage(UIImage(systemName: "xmark.square"), for: .selected)
        sender.setImage(UIImage(systemName: "square"), for: .normal)
        validateInputs()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailField.text, let password = passwordField.text else {
            // Handle the error if email or password is nil
            print("Email or Password is nil")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                   if let error = error {
                       print("Error in creating user: \(error.localizedDescription)")
                   } else {
                       print("User created successfully")
                       self?.delegate?.userDidSignUpSuccessfully()
                       self?.dismiss(animated: true, completion: nil)
                   }
               }
    }

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == passwordField {
            passwordChanged(textField)
        }
        validateInputs()
    }

    
    @IBAction func dismissModal(_ sender: Any) {
        self.resignFirstResponder()
        self.dismiss(animated: true)
    }
    

}

//actual spagetti but just for rn  fr fr

protocol CreateUserVCDelegate: AnyObject {
    func userDidSignUpSuccessfully()
}
