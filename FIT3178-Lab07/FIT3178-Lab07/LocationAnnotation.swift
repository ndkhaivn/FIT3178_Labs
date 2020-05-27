//
//  LocationAnnotation.swift
//  FIT3178-Lab07
//
//  Created by Nguyễn Đình Khải on 26/5/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import MapKit
class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(title: String, subtitle: String, lat: Double, long: Double) {
        self.title = title
        self.subtitle = subtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
