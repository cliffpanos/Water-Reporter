//
//  MainViewController.swift
//  CS2340-iOS
//
//  Created by Cliff Panos on 4/8/17.
//
//

import UIKit

class MainViewController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard AuthManager.shared.current() != nil else {
            return
        }
        
        print("Will present loginViewController")
        let loginController = AppConstants.storyboard.instantiateViewController(withIdentifier: "loginViewController")
        self.present(loginController, animated: false, completion: nil)
    
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
