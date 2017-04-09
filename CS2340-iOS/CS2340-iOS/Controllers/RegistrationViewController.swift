//
//  RegistrationViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameText.becomeFirstResponder()
        errorMessageLabel.text = ""
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let username = usernameText?.text, let password = passwordText?.text, let confirmPassword = confirmPasswordText?.text {
            if username.characters.count == 0 {
                
                return
            }
            if password.characters.count == 0 {
                
                return
            }
            if confirmPassword.characters.count == 0 {
                
                return
            }
            if confirmPassword != password {
                
                return
            }
            
            AuthManager.shared.registerStandard(username: username, password: password) {
                (isSuccessful) -> Void in
                if (isSuccessful) {
                    self.performSegue(withIdentifier: "registrationToProfile", sender: nil)
                } else {
                    print("Registration Unsuccessful")
                }
            }
        }
        
        func badLoginFeedback() {
            self.errorMessageLabel.text = "Invalid Login"
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.repeatCount = 3
            animation.duration = 0.07
            animation.autoreverses = true
            animation.byValue = 7
            self.usernameText.layer.add(animation, forKey: "position")
            self.passwordText.layer.add(animation, forKey: "position")
            self.confirmPasswordText.layer.add(animation, forKey: "position")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registrationToProfile" {
            let profileViewController = segue.destination as? EditProfileViewController
            profileViewController?.fromRegistration = true
        }
    }



}
