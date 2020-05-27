//
//  NewLocationViewController.swift
//  FIT3178-Lab07
//
//  Created by Nguyễn Đình Khải on 26/5/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import MapKit

protocol NewLocationDelegate: NSObject {
    func locationAnnotationAdded(annotation: LocationAnnotation)
}

class NewLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var useCurrentLocationButton: UIButton!
    
    weak var delegate: NewLocationDelegate?
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    @IBAction func useCurrentLocation(_ sender: Any) {
        if let currentLocation = currentLocation {
            latitudeTextField.text = "\(currentLocation.latitude)"
            longitudeTextField.text = "\(currentLocation.longitude)"
        } else {
            let alertController = UIAlertController(title: "Location Not Found",
                                                    message: "The location has not yet been determined.",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style:
                .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        guard let lat = Double(latitudeTextField.text!),
            let long = Double(longitudeTextField.text!) else {
                let alertController = UIAlertController(title: "Co-ordinates invalid",
                                                        message: "Lat & Long must be numbers", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style:
                    .default, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        let newLocation = LocationAnnotation(title: titleTextField.text!,
                                             subtitle: descriptionTextField.text!, lat: lat, long: long)
        delegate?.locationAnnotationAdded(annotation: newLocation)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        
        let authorisationStatus = CLLocationManager.authorizationStatus()
        if authorisationStatus != .authorizedWhenInUse {
            // If not currently authorised, hide button
            useCurrentLocationButton.isHidden = true
            if authorisationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - CLLocationManager delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
        locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization
        status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            useCurrentLocationButton.isHidden = false
        }
    }

}
