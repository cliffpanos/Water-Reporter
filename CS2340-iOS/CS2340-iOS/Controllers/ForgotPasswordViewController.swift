//
//  ForgotPasswordViewController.swift
//  CS2340-iOS
//
//  Created by Cliff Panos on 4/26/17.
//
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pre-populate the email field with the current user's email if possible
        if let email = AuthManager.shared.current()?.email {
            emailTextField.text = email
        }
        
        errorMessage.text = ""
    
    }
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        
        if (emailTextField.text ?? "") != "" {
            errorMessage.text = ""
        } else {
            errorMessage.text = "Please enter an email address"
            return
        }
        
        //Confirm that the user really wants to reset his or her password
        let confirmationAlert = UIAlertController(title: "Confirm Reset", message: "Are you sure you want to reset your password?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { _ in self.resetPassword()
        }
        
        confirmationAlert.addAction(cancelAction)
        confirmationAlert.addAction(resetAction)
        self.present(confirmationAlert, animated: true, completion: nil)
        
    }
    
    func resetPassword() -> Void {
        
        let email = emailTextField.text ?? ""
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
            
            if error == nil {
                let alert = UIAlertController(title: "Reset Successful", message: "Your password reset instructions have been sent to the specified email address.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.errorMessage.text = "An error occurred while trying to reset your password"
            }
        }
        
        errorMessage.text = ""
    
    }
    

    // MARK: - Navigation
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
