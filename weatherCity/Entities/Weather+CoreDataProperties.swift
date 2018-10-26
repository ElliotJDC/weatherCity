//
//  Weather+CoreDataProperties.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var nebulocite: Float
    @NSManaged public var temperature: Float
    @NSManaged public var pression: Float
    @NSManaged public var rain: Float
    @NSManaged public var humidity: Float
    @NSManaged public var wind_average: Float
    @NSManaged public var wind_rafale: Float
    @NSManaged public var snow_alerte: Bool
    @NSManaged public var date_of_request: NSDate?
    @NSManaged public var for_date: NSDate?
    @NSManaged public var geoloc: Geoloc?
    @NSManaged public var city: City?

}
