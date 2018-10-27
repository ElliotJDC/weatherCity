//
//  GeolocManager.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import UIKit
import CoreLocation

public struct Coordinate {
    let latitude: Double
    let longitude:Double
    let findedDate:Date
}

class GeolocManager: NSObject {
    
    static let sharedManager:GeolocManager = GeolocManager()
    
    private let geocoder:CLGeocoder!
    private let locationManager:CLLocationManager!
    
    public var lastCoordinateKnow:Coordinate?
    
    override init() {
        geocoder = CLGeocoder()
        locationManager = CLLocationManager()
        
        super.init()
        
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
    }
    
    public func startLocationManager() -> Void {
        self.locationManager.startUpdatingLocation()
    }
    
    public func stopLocationManger() -> Void {
        self.locationManager.stopUpdatingLocation()
    }
    
}



// MARK: CLLocationManagerDelegate

extension GeolocManager : CLLocationManagerDelegate {
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("location manager pause")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("location manager re start")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("location manager start")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("find a location manager")
        if locations.count != 0 {
            
            let location:CLLocation = locations[0]
            let coordinate = location.coordinate
            
            let coordinateStruct = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude, findedDate: Date())
            
            self.lastCoordinateKnow = coordinateStruct
            
            self.geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
                
                if let error = error {
                    print("error on get placeMark from location", error)
                    return
                }
                if let placeMark = placeMarks?[0] {
                    guard let city = placeMark.locality else { return }
                    
                    _ = City.city(name: city, location: coordinateStruct)
                }
            }
            
        }
        
        return
    }
    
}

// MARK: Coordinate from City or place name

extension GeolocManager {
    
    public func getCoordinate(addressString:String, completion:@escaping(_ latitude:Double, _ longitude:Double ) -> Void ) -> Void {
        
        self.geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            
            if let error = error {
                print("error searching location for", addressString, error)
                completion(0.0, 0.0)
                return
            }
            
            guard let placemark:CLPlacemark = placemarks?[0] else {
                completion(0.0, 0.0)
                return
            }
            guard let location = placemark.location else {
                completion(0.0, 0.0)
                return
            }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            completion(latitude, longitude)
            return
            
        }
        
    }
    
}
