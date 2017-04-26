
//
//  MapViewController.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var gestureRecognizer: UILongPressGestureRecognizer!
    
    static var reportRegionToView: Report?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
        }
        
        //TODO remove this
        //let hackGSU = ReportLocation(name: "HackGSU",lat: 33.7563920891773, long: -84.3890242522629, data: nil)
        //mapView.addAnnotation(hackGSU as MKAnnotation)
        
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "CurrentLocation"), style: .done, target: self, action: #selector(zoomToUserLocation))
        navigationItem.rightBarButtonItem = button
        
        gestureRecognizer.minimumPressDuration = 0.75
        gestureRecognizer.addTarget(self, action: #selector(handle(gesture:)))
        gestureRecognizer.delaysTouchesBegan = true        
        
        let service = FirebaseService(table: .users)
        
        let uid = AuthManager.shared.current()?.uid
        service.retrieveData(forIdentifier: uid!) {
            (result) -> Void in
            if let user = result as? User {
                let sourceService = FirebaseService(table: .sourceReports)
                sourceService.retrieveAll() {
                    (reports) -> Void in
                    for report in reports {
                        self.createMarker(report: (report as? Report)!)
                    }
                }
                if user.userType != "User" {
                    let purityService = FirebaseService(table: .purityReports)
                    purityService.retrieveAll() {
                        (reports) -> Void in
                        for report in reports {
                            self.createMarker(report: (report as? Report)!)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let report = MapViewController.reportRegionToView {
            
            let location = (report.toDictionary())["location"] as! String
            let locationComponents = location.components(separatedBy: ",")
            
            guard locationComponents.count > 1 else {
                return
            }
            
            if let lat = Double(locationComponents[0]), let long = Double(locationComponents[1]) {
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                zoom(to: coord)
            }
            MapViewController.reportRegionToView = nil
            
        }
    }

    func zoomToUserLocation() {
        zoom(to: mapView.userLocation.coordinate)
    }
    
    func zoom(to location: CLLocationCoordinate2D) {
        let newRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        do {
            try mapView.setRegion(newRegion, animated: true)
        } catch is NSException {
            print("Invalid region")
        }
        
    }
    
    func createMarker(report: Report) {
        
        let location = report.location
        let locationComponents = location.components(separatedBy: ",")
        
        guard locationComponents.count > 1 else {
            return
        }

        let latDouble = (locationComponents[0] as NSString).doubleValue
        let longDouble = (locationComponents[1] as NSString).doubleValue
        
        let marker = ReportLocation(name: report.reportNumber, lat: latDouble, long: longDouble, data: report)
        mapView.addAnnotation(marker)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? ReportLocation else {return nil}
        
        let identifier = "reportLocation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
            let button = UIButton(type: (annotation.report != nil ? .detailDisclosure : .contactAdd))
            annotationView!.rightCalloutAccessoryView = button

        } else {
            annotationView!.annotation = annotation
        }

        /*if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            
            annotationView = dequeuedView
        
        } else { //make a new view
            annotationView = ReportMapPopup(annotation: annotation, reuseIdentifier: "identifier")
        }*/
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let pin = view.annotation as! ReportLocation
        
        var controller: UIViewController!
        if let report = pin.report {
            
            controller = AppConstants.storyboard.instantiateViewController(withIdentifier: "pinDetailViewController")
            (controller as! PinDetailViewController).pin = pin
            (controller as! PinDetailViewController).report = report
        } else {
            controller = AppConstants.storyboard.instantiateViewController(withIdentifier: "editReportViewController")
            (controller as! EditReportViewController).pin = pin
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
    var currentlyRecognizing = false
    
    func handle(gesture: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.recognized {
            currentlyRecognizing = false
        }
        
        guard gestureRecognizer.state == UIGestureRecognizerState.began && !currentlyRecognizing else {
            return
        }
        
        currentlyRecognizing = true
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        let pin = ReportLocation(location: coordinate)
        mapView.addAnnotation(pin)

    }
    
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
