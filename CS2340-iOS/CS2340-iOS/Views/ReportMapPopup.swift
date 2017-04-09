//
//  ReportMapPopup.swift
//  CS2340-iOS
//
//  Created by Daniel Becker on 4/8/17.
//
//

import MapKit

class ReportMapPopup: MKAnnotationView {
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var submittedBy: UILabel!
    
    @IBOutlet weak var type: UILabel!
}
