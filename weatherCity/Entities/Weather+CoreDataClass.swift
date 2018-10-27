//
//  Weather+CoreDataClass.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Weather)
public class Weather: NSManagedObject {
    
    public class func fetchDataWeather(coordonate:Coordinate) -> Void {
        WeatherHttpManager.sharedManager.getDataMeteoForCoordinate(latitude: coordonate.latitude, longitude: coordonate.longitude) { (dictionary) in
            
            guard let dict = dictionary else { return }
            
            for key:String in dict.keys {
                guard let weatherDict = dict[key] as? [String:Any] else {
                    continue
                }
                print(weatherDict)
            }
            
        }
    }
    
}
