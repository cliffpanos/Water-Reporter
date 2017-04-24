//
//  EditPropertiesViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/24/17.
//
//

import UIKit

class EditPropertiesViewController: UITabBarController {
    
    var editSource : EditSourceViewController?
    var editPurity : EditPurityViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.isHidden = true
        
        editSource = self.viewControllers?[0] as? EditSourceViewController
        editPurity = self.viewControllers?[1] as? EditPurityViewController
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSource() {
        self.selectedIndex = 0
    }
    
    func showPurity() {
        self.selectedIndex = 1
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

class EditSourceViewController: UIViewController {
    @IBOutlet weak var typeSelector: UISegmentedControl!
    
}

class EditPurityViewController: UIViewController {
    @IBOutlet weak var contaminantPPM: UITextField!
    @IBOutlet weak var virusPPM: UITextField!
    
}
