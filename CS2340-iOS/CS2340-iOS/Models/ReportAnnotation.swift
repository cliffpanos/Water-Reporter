//
//  ReportAnnotation.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import Foundation
import MapKit

class ReportLocation: NSObject, MKAnnotation{
    var identifier = "report location"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var report : Report!
    
    init(name:String,lat:CLLocationDegrees,long:CLLocationDegrees, data : Report){
        title = name
        coordinate = CLLocationCoordinate2DMake(lat, long)
        report = data
    }
}
