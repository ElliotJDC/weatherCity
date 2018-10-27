//
//  Geoloc+CoreDataProperties.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 27/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//
//

import Foundation
import CoreData


extension Geoloc {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Geoloc> {
        return NSFetchRequest<Geoloc>(entityName: "Geoloc")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var city: City?
    @NSManaged public var weather: Weather?

}
