//
//  HomePageViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import UIKit

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        AuthManager.shared.logOut() {
            (isSuccessful) -> Void in
            if isSuccessful {
                self.present(AppConstants.storyboard.instantiateViewController(withIdentifier: "loginViewController"), animated: true, completion: nil)
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
