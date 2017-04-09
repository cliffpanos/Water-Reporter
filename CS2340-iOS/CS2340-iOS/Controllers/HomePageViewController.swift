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
    
    var allReports: [[Report]] = [[]]
    //[[Source],[Purity]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allReports = [[Report]()]
        allReports[0] = [SourceReport]()
        allReports[1] = [PurityReport]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let service = FirebaseService(table: .users)
        let uid = AuthManager.shared.current()?.uid
        service.retrieveData(forIdentifier: uid!) { result in
            
            if let user = result as? User {
                service.table = FirebaseTable.sourceReports
                service.retrieveAll() {
                    (reports) -> Void in
                    for report in reports {
                        self.allReports[0].append(report as! SourceReport)
                    }
                }
                if user.userType != "User" {
                    service.table = FirebaseTable.purityReports
                    service.retrieveAll() {
                        (reports) -> Void in
                        for report in reports {
                            self.allReports[1].append(report as! PurityReport)
                        }
                    }
                }
            }
            
            
        }
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
