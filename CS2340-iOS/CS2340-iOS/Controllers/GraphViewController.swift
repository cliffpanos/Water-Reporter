//
//  GraphViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/25/17.
//
//

import UIKit
import MapKit
import Charts

class GraphViewController: UIViewController {
    
    var location : CLLocationCoordinate2D?

    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var chart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Historical Reports"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func load(_ sender: BorderedButton) {
        if year.text?.characters.count == 4 {
            let service = FirebaseService(table: .purityReports)
            service.retrieveAll() {
                (result) -> Void in
                var toDisplay : [PurityReport] = []
                for report in result {
                    if let purity = report as? PurityReport {
                        let locationComponents = purity.location.components(separatedBy: ",")
                        
                        guard locationComponents.count > 1 else {
                            return
                        }
                        
                        let latDouble = (locationComponents[0] as NSString).doubleValue
                        let longDouble = (locationComponents[1] as NSString).doubleValue
                        let validLat = fabs((self.location?.latitude)! - latDouble) < 0.01
                        let validLong = fabs((self.location?.longitude)! - longDouble) < 0.01
                        if purity.dateTimeString.contains(self.year.text!) && validLat && validLong {
                            toDisplay.append(purity)
                        }
                    }
                }
                self.updateGraph(reports: toDisplay)
            }
        }
    }
    
    func updateGraph(reports : [PurityReport]) {
        var data = [Double](repeating: 0.0, count: 12)
        var count = [Double](repeating: 0.0, count: 12)
        let calendar = Calendar.current
        let isContaminant = type.selectedSegmentIndex == 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM dd HH:mm:ss z yyyy"
        for report in reports {
            let date = dateFormatter.date(from: report.dateTimeString)
            let month = calendar.component(.month, from: date!)
            if isContaminant {
                data[month] += report.containmentPPM
            } else {
                data[month] += report.virusPPM
            }
            count[month] += 1
        }
        
        var yVals : [ChartDataEntry] = []
        for i in 0...11 {
            yVals.append(ChartDataEntry(x: Double(i + 1), y: data[i] / count[i]))
        }
        let dataSet = LineChartDataSet(values: yVals, label: "PPM")
        dataSet.drawFilledEnabled = true
        let chartData = LineChartData(dataSet: dataSet)
        
        chart.isHidden = false
        chart.data = chartData
        chart.updateFocusIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
