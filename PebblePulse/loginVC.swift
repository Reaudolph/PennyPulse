//
//  loginVC.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/17/23.
//

import UIKit
import Lottie

class loginVC: UIViewController {

    @IBOutlet weak var animViewLogin: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        animViewLogin.contentMode = .scaleAspectFit
        animViewLogin.loopMode = .loop
        animViewLogin.animationSpeed = 0.8
        animViewLogin.play()

        // Do any additional setup after loading the view.
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
