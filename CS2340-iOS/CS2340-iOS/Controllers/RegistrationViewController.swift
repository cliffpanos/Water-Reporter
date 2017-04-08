//
//  RegistrationViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    print("Registration Successful")
                } else {
                    print("Registration Unsuccessful")
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
