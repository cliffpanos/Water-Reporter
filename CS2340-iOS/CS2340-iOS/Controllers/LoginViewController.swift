//
//  LoginViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorMessageLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let username = usernameText?.text, let password = passwordText?.text {
            if username.characters.count == 0 {
                
                badLoginFeedback()
                return
            }
            if password.characters.count == 0 {
                
                badLoginFeedback()
                return
            }
            
            AuthManager.shared.loginStandard(username: username, password: password) {
                (isSuccessful) -> Void in
                if (isSuccessful) {
                    self.errorMessageLabel.text = ""

                    let mainController = AppConstants.storyboard.instantiateViewController(withIdentifier: "main")
                    self.present(mainController, animated: true, completion: nil)
                } else {
                    self.badLoginFeedback()
                }
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
        animation.byValue = 7 //how much it moves
        self.usernameText.layer.add(animation, forKey: "position")
        self.passwordText.layer.add(animation, forKey: "position")
    }

}
