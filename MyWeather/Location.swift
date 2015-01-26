//
//  Location.swift
//  MyWeather
//
//  Created by Mikael Kopteff on 26/01/15.
//  Copyright (c) 2015 Mikael Kopteff. All rights reserved.
//

import Foundation
import UIKit
import MapKit

 class Location: NSObject, CLLocationManagerDelegate {
    let locationManager :CLLocationManager! = nil
    var locationCache: CLLocation? = nil
    var callback: (CLLocation -> ())?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManagerSetup()
    }
    
    func callback(fn: CLLocation -> Void) {
        callback = fn
    }

    func locationManagerSetup() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 1000
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        NSLog("locations = \(locations)")
        let lastLoc: CLLocation = locations[locations.count - 1] as CLLocation
        locationCache = lastLoc
        if let fn = callback {
            fn(lastLoc)
        }
    }
    
    func cache() -> CLLocation? {
        return locationCache
    }
}
