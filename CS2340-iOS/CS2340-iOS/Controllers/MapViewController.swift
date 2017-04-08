
//
//  MapViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let service = FirebaseService(table: .users)
        
        let uid = AuthManager.shared.current()?.uid
        
        mapView.delegate = self
        
        service.retrieveData(forIdentifier: uid!) {
            (result) -> Void in
            if let user = result as? User {
                service.table = FirebaseTable.sourceReports
                service.retrieveAll() {
                    (reports) -> Void in
                    for report in reports {
                        self.createMarker(report: (report as? Report)!)
                    }
                }
                if user.userType != "User" {
                    service.table = FirebaseTable.purityReports
                    service.retrieveAll() {
                        (reports) -> Void in
                        for report in reports {
                            self.createMarker(report: (report as? Report)!)
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createMarker(report: Report) {
        let commaIndex = report.location.index(of: ",")!
        let latDouble = (report.location.substring(to: commaIndex) as NSString).doubleValue
        let tempString = report.location.substring(from: commaIndex)
        let newIndex = tempString.index(tempString.startIndex, offsetBy: 1)
        let longDouble = (tempString.substring(from: newIndex) as NSString).doubleValue
        let lat = CLLocationDegrees(floatLiteral: latDouble)
        let long = CLLocationDegrees(floatLiteral: longDouble)
        let marker = ReportLocation(name: report.reportNumber, lat: lat, long: long, data: report)
        mapView.addAnnotation(marker)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view : MKAnnotationView
        guard let annotation = annotation as? ReportLocation else {return nil}
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? MKPinAnnotationView
        {
            view = dequeuedView
        }else { //make a new view
            view = ReportMapPopup(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        return view
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

extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}
