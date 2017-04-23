//
//  HomePageViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reportTypeSelector: UISegmentedControl!
    
    var allReports: [[Report]] = [[SourceReport](), [PurityReport]()]
    //[[Source],[Purity]]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let service = FirebaseService(table: .users)
        let uid = AuthManager.shared.current()?.uid
        service.retrieveData(forIdentifier: uid!) { result in
            
            if let user = result as? User {
                let sourceService = FirebaseService(table: .sourceReports)
                sourceService.table = FirebaseTable.sourceReports
                sourceService.retrieveAll() {
                    (reports) -> Void in
                    for report in reports {
                        self.allReports[0].append(report as! SourceReport)
                    }
                    self.tableView.reloadData()

                }
                if user.userType != "User" {
                    
                    let purityService = FirebaseService(table: .purityReports)
                    purityService.table = FirebaseTable.purityReports
                    purityService.retrieveAll() {
                        (reports) -> Void in
                        for report in reports {
                            self.allReports[1].append(report as! PurityReport)
                        }
                        self.tableView.reloadData()

                    }
                }
            }
            
            
        }
        
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        AuthManager.shared.logOut() {
            (isSuccessful) -> Void in
            if isSuccessful {
                self.present(AppConstants.storyboard.instantiateViewController(withIdentifier: "loginViewController"), animated: true, completion: nil)
            }
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? ReportCell {
            
            let dest = segue.destination as! PinDetailViewController
            let relevantReports = allReports[reportTypeSelector.selectedSegmentIndex]
            dest.report = relevantReports[(tableView.indexPath(for: cell)?.row)!]
        }

    }
    
}


//MARK: - Table View Data & Delegation
extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let reportTypeIndex = reportTypeSelector.selectedSegmentIndex
        return allReports[reportTypeIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reportTypeIndex = reportTypeSelector.selectedSegmentIndex
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! ReportCell
        
        let reportArray = allReports[reportTypeIndex]
        let report = reportArray[indexPath.row]
        cell.decorate(for: report)
        
        return cell
    }
    
}

class ReportCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    func decorate(for report: Report) {
        switch report {
        case let purityReport as PurityReport:
            typeLabel.text = "Condition: \(purityReport.condition)"
            conditionLabel.text = "Impurity PPMs: \(purityReport.virusPPM) / \(purityReport.containmentPPM)"
        
        case let sourceReport as SourceReport:
            typeLabel.text = "Water Type: \(sourceReport.type)"
            conditionLabel.text = "Condition: \(sourceReport.condition)"
        
        default:
            break
        }

    }
    
    
}
