//
//  registerViewController.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/17/23.
//

import Foundation
import UIKit
import Lottie



class registerViewController : UIViewController {
    var nav = UINavigationController()
    @IBOutlet weak var animView: LottieAnimationView!
    
    override func viewDidLoad() {
        animView.contentMode = .scaleAspectFit
        animView.loopMode = .loop
        animView.animationSpeed = 0.8
        animView.play()
        super.viewDidLoad()
    }
    
    @IBAction func signUpWithEmail(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "createUserVC") as! createUserVC
        //        signUpVC.runCount = self.runCount
        self.nav = UINavigationController(rootViewController: signUpVC)
        if #available(iOS 16.0, *) {
            if let sheets = self.nav.sheetPresentationController {
                let presentationId = UISheetPresentationController.Detent.Identifier("signUpSheet")
                let detent = UISheetPresentationController.Detent.custom(identifier: presentationId) { context in
                    return 468
                }
                sheets.detents = [detent]
                sheets.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        } else {
            if #available(iOS 15.0, *) {
                if let sheets = self.nav.sheetPresentationController {
                    sheets.detents = [.medium()]
                    sheets.prefersScrollingExpandsWhenScrolledToEdge = false
                }
            }
        }
        self.nav.modalPresentationStyle = .pageSheet
        self.present(self.nav, animated: true, completion: nil)
    }
    
}
