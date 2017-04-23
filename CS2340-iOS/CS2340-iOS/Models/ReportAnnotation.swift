//
//  ReportAnnotation.swift
//  CS2340-iOS
//
//  Created by Daniel Becker & Cliff Panos on 4/8/17.
//
//

import UIKit
import MapKit

class ReportLocation: NSObject, MKAnnotation {
    
    //for some reason the commented line of code below messed up things
    //var identifier = "identifier"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var report : Report?
    
    init(name: String, lat:CLLocationDegrees, long:CLLocationDegrees, data : Report?){
        if data is SourceReport {
            title = "Source Report"
        } else if data is PurityReport {
            title = "Purity Report"
        } else {
            title = "New Report"
        }
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        report = data
    }
    
    init(location: CLLocationCoordinate2D) {
        title = "New Report"
        coordinate = location
        report = nil
    }
}
