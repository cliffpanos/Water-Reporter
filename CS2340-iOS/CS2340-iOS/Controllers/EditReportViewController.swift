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
    
    var pin: ReportLocation?
    var report: Report? //nil if creating a new Report
    
    var propertiesTabBar : EditPropertiesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let report = report {
            
            //Setup the view and pre-fill known information
            reportTypeControl.selectedSegmentIndex = (report is SourceReport ? 0 : 1)
            reportTypeControl.isEnabled = false
            
        } else { //Band-aid fix to save views
            
            let toRemove = reportTypeControl.constraints
            reportTypeControl.removeConstraints(toRemove)
            
            let constraint = NSLayoutConstraint(item: reportTypeControl, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 24)
            NSLayoutConstraint.activate([constraint])
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedTabBar" {
            propertiesTabBar = segue.destination as? EditPropertiesViewController
        }
    }

    @IBAction func toggleReportType(_ sender: Any) {
        if (reportTypeControl.selectedSegmentIndex == 0) {
            propertiesTabBar?.showSource()
        } else {
            propertiesTabBar?.showPurity()
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
