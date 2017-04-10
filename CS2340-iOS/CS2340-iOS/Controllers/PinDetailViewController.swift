//
//  PinDetailViewController.swift
//  CS2340-iOS
//
//  Created by Cliff Panos on 4/9/17.
//
//

import UIKit

class PinDetailViewController: UIViewController {
    
    var report: Report!
    var pin: ReportLocation!

    @IBOutlet weak var waterReportTypeLabel: UILabel!
    
    @IBOutlet weak var property1: UILabel!
    @IBOutlet weak var property2: UILabel!
    @IBOutlet weak var property3: UILabel!
    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let reportType = report is SourceReport ? "Source" : "Purity"
        waterReportTypeLabel.text = "Water \(reportType) Report"
        
    }
    
    @IBAction func viewInMapPressed(_ sender: Any) {
        AppConstants.appDelegate.tabBarController.selectedIndex = 1
        
        //TODO implement zoom to location
        //mapViewCntroller.zoom(to: report.l)
    }

    @IBAction func deleteReportPressed(_ sender: Any) {
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
