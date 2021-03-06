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

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(presentEditReportController))
        
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "Graph"), style: .done, target: self, action: #selector(graph))
        navigationItem.rightBarButtonItem = button
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard report != nil else {
            presentEditReportController()
            return
        }
        

        if let report = report as? SourceReport {
            
            waterReportTypeLabel.text = "Water Source Report"
            property2.text = "Water Type: \(report.type)"
            //property3.removeFromSuperview()
            property3.text = ""
        
        } else if let report = report as? PurityReport {
            
            waterReportTypeLabel.text = "Water Purity Report"
            property2.text = "Contaminant PPM: \(report.containmentPPM)"
            property3.text = "Virus PPM: \(report.virusPPM)"
            
        }
        
        property1.text = "Condition: \(report.condition)"
        let location = (report.toDictionary())["location"] as! String
        let locationComponents = location.components(separatedBy: ",")
        
        if locationComponents.count > 1 {
            latLabel.text = "Latitude: \(locationComponents[0])"
            longLabel.text = "Longitude: \(locationComponents[1])"
        }

    }
    
    func graph() {
        performSegue(withIdentifier: "graph", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "graph" {
            let vc = segue.destination as? GraphViewController
            vc?.location = pin.coordinate
        }
    }
    
    @IBAction func viewInMapPressed(_ sender: Any) {
        MapViewController.reportRegionToView = self.report
        self.tabBarController?.selectedIndex = 1

    }

    @IBAction func deleteReportPressed(_ sender: Any) {
        let service = FirebaseService()
        if report is PurityReport {
            service.table = FirebaseTable.purityReports
        } else if report is SourceReport {
            service.table = FirebaseTable.sourceReports
        }
        service.deleteData(forIdentifier: report.identifier)
        self.navigationController?.popViewController(animated: true)
        let parent = navigationController?.topViewController
        if let map = parent as? MapViewController {
            map.mapView.removeAnnotation(pin)
        }
        parent?.view?.setNeedsDisplay()
    }
    
    func presentEditReportController() {
        let editReportController = AppConstants.storyboard.instantiateViewController(withIdentifier: "editReportViewController") as! EditReportViewController
        editReportController.report = report
        editReportController.pin = pin
        self.present(editReportController, animated: false, completion: nil)
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
