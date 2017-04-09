//
//  EditProfileViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var userTypeText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var emailAddressText: UITextField!
    
    var fromRegistration : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromRegistration {
            emailAddressText.text = AuthManager.shared.current()?.email
        } else {
            let userId = AuthManager.shared.current()?.uid
            
            let service = FirebaseService(table: .users)
            service.retrieveData(forIdentifier: userId!) {
                (result) -> Void in
                if let user = result as? User {
                    self.addressText.text = user.address
                    self.userTypeText.text = user.userType
                    self.emailAddressText.text = user.emailAddress
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    
    @IBAction func submit(_ sender: UIButton) {
        let service = FirebaseService(table: .users)
        
        let userId = AuthManager.shared.current()?.uid
        
        let user = User()
        user.address = (addressText?.text!)!
        user.emailAddress = (emailAddressText?.text!)!
        user.userType = (userTypeText?.text!)!
        service.enterData(forIdentifier: userId!, data: user)
        
        AuthManager.shared.updateEmail(newEmail: emailAddressText.text!)
        
        if fromRegistration {
            self.present(AppConstants.storyboard.instantiateInitialViewController()!, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
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
