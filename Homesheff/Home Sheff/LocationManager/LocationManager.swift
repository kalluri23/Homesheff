//
//  LocationManager.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 1/17/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import MapKit

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager: CLLocationManager
    
    var currentLocation : CLLocation
    
    private override init() {
        locationManager = CLLocationManager()
        currentLocation = CLLocation()
        super.init()
        locationManager.delegate = self
    }
    
    func requestForLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if let currentLocation = manager.location {
                self.currentLocation = currentLocation
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0, let currentLoc = locations.first {
            currentLocation = currentLoc
        }
    }
    
}
