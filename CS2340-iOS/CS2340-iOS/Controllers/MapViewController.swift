
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
        let hackGSU = ReportLocation(name: "HackGSU",lat: 33.7563920891773, long: -84.3890242522629, data: nil)
        mapView.addAnnotation(hackGSU as MKAnnotation)
        
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "CurrentLocation"), style: .done, target: self, action: #selector(zoomToLocation))
        navigationItem.rightBarButtonItem = button
        
        gestureRecognizer.minimumPressDuration = 0.75
        gestureRecognizer.addTarget(self, action: #selector(handle(gesture:)))
        gestureRecognizer.delaysTouchesBegan = true        
        
        let service = FirebaseService(table: .users)
        
        let uid = AuthManager.shared.current()?.uid
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

    func zoomToLocation() {
        let userRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(userRegion, animated: true)
    }
    
    func createMarker(report: Report) {
        return
        guard let commaIndex = report.location.index(of: ",") else {
            return
        }
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
        
        let detailController = AppConstants.storyboard.instantiateViewController(withIdentifier: "pinDetailViewController") as! PinDetailViewController
        detailController.pin = pin
        self.navigationController?.pushViewController(detailController, animated: true)
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
