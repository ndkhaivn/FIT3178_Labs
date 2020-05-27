//
//  LocationTableViewController.swift
//  FIT3178-Lab07
//
//  Created by Nguyễn Đình Khải on 26/5/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import MapKit



class LocationTableViewController: UITableViewController, NewLocationDelegate {
    
    weak var mapViewController: MapViewController?
    var locationList = [LocationAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        var location = LocationAnnotation(title: "Monash Uni - Caulfield",
                                          subtitle: "The Caulfield Campus of the Uni",
                                          lat: -37.877623, long: 145.045374)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(title: "Monash Uni - Clayton",
                                      subtitle: "The Clayton Campus of the Uni",
                                      lat: -37.9105238, long: 145.1362182)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return locationList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "locationCell", for: indexPath)
        let annotation = self.locationList[indexPath.row]
        
        cell.textLabel?.text = annotation.title
        cell.detailTextLabel?.text = "Lat: \(annotation.coordinate.latitude) Long: \(annotation.coordinate.longitude)"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locationList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        mapViewController?.focusOn(annotation: self.locationList[indexPath.row])
        if let mapVC = mapViewController {
            splitViewController?.showDetailViewController(mapVC, sender: nil)
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationSegue" {
            let controller = segue.destination as! NewLocationViewController
            controller.delegate = self
        }
    }
    // MARK: - New Location Delegate
    func locationAnnotationAdded(annotation: LocationAnnotation) {
        locationList.append(annotation)
        tableView.insertRows(at: [IndexPath(row: locationList.count - 1,
                                            section: 0)], with: .automatic)
        mapViewController?.mapView.addAnnotation(annotation)
    }
    
    
}
