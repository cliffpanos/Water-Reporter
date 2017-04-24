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
    @IBOutlet weak var conditionControl: UISegmentedControl!
    
    var pin: ReportLocation?
    var report: Report? //nil if creating a new Report
    
    var propertiesTabBar : EditPropertiesViewController?
    
    var conditionOptions = ["Potable", "Waste", "Clear", "Muddy"]
    var typeOptions = ["Bottled", "Lake", "Well", "Spring", "Stream"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let report = report {
            reportTypeControl.isEnabled = false
            conditionControl.selectedSegmentIndex = conditionOptions.index(of: report.condition)!
            //Setup the view and pre-fill known information
            if let sourceReport = report as? SourceReport { 
                propertiesTabBar?.editSource?.selectedIndex = typeOptions.index(of: sourceReport.type)!
            } else if let purityReport = report as? PurityReport {
                reportTypeControl.selectedSegmentIndex = 1
                propertiesTabBar?.selectedIndex = 1
                propertiesTabBar?.editPurity?.contaminant = purityReport.containmentPPM
                propertiesTabBar?.editPurity?.virus = purityReport.virusPPM
            }
            
            
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
        let service = FirebaseService()
        if report == nil { // creating a new report
            if reportTypeControl.selectedSegmentIndex == 0 {
                report = SourceReport()
                service.table = FirebaseTable.sourceReports
            } else  {
                report = PurityReport()
                service.table = FirebaseTable.purityReports
            }
            report?.userId = (AuthManager.shared.current()?.email)!
            report?.reportNumber = service.getKey()
            report?.location = (pin?.coordinate.latitude.description)! + "," + (pin?.coordinate.longitude.description)!
            
        } else {
            if report is SourceReport {
                service.table = FirebaseTable.sourceReports
            } else {
                service.table = FirebaseTable.purityReports
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM dd HH:mm:ss z yyyy"
        report?.dateTimeString = dateFormatter.string(from: Date())
        report?.condition = conditionOptions[conditionControl.selectedSegmentIndex]
        if let sourceReport = report as? SourceReport {
            sourceReport.type = typeOptions[(propertiesTabBar?.editSource?.typeSelector.selectedSegmentIndex)!]
            service.enterData(forIdentifier: sourceReport.reportNumber, data: sourceReport)
        } else if let purityReport = report as? PurityReport {
            purityReport.containmentPPM = Double((propertiesTabBar!.editPurity?.contaminantPPM.text)!)!
            purityReport.virusPPM = Double((propertiesTabBar?.editPurity?.virusPPM.text)!)!
            service.enterData(forIdentifier: purityReport.reportNumber, data: purityReport)
        }
        //exitViewController()
        self.navigationController?.popViewController(animated: true)
        let parent = self.navigationController?.topViewController
        if let map = parent as? MapViewController {
            let newPin = ReportLocation(name: (report?.reportNumber)!, lat: (pin?.coordinate.latitude)!, long: (pin?.coordinate.longitude)!, data: report)
            map.mapView.removeAnnotation(pin!)
            map.mapView.addAnnotation(newPin)
        }
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
