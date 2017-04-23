//
//  EditReportViewController.swift
//  CS2340-iOS
//
//  Created by Cliff Panos on 4/23/17.
//
//

import UIKit

class EditReportViewController: UIViewController {

    @IBOutlet weak var reportTypeControl: UISegmentedControl!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var property1: UILabel!
    @IBOutlet weak var property2: UILabel!
    @IBOutlet weak var property3: UILabel!
    
    var pin: ReportLocation?
    var report: Report? //nil if creating a new Report
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let report = report {
            
            //Setup the view and pre-fill known information
            reportTypeControl.selectedSegmentIndex = (report is SourceReport ? 0 : 1)
            
        } else { //Band-aid fix to save views
            
            let toRemove = reportTypeControl.constraints
            reportTypeControl.removeConstraints(toRemove)
            
            let constraint = NSLayoutConstraint(item: reportTypeControl, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 24)
            NSLayoutConstraint.activate([constraint])
        }
        
        
    }

    @IBAction func cancelPressed(_ sender: Any) {
        exitViewController()
    }

    @IBAction func saveReportPressed(_ sender: Any) {
        exitViewController()
        //TODO update Report Object

    }
    
    func exitViewController() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: false, completion: nil)
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
