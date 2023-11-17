//
//  registrationViewController.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/12/23.
//

import Foundation
import UIKit
import Lottie


class onboardingHome : UIViewController {
    @IBOutlet weak var onboardingLottieAnim: LottieAnimationView!
    
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad (){
        super.viewDidLoad()
        // Setting up the lottie animation
        onboardingLottieAnim.contentMode = .scaleAspectFit
        onboardingLottieAnim.loopMode = .loop
        onboardingLottieAnim.animationSpeed = 0.5
        onboardingLottieAnim.play()
        
        backView.layer.cornerRadius = 6
        
        
        
    }
}
