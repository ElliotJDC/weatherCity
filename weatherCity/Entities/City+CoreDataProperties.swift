//
//  City+CoreDataProperties.swift
//  
//
//  Created by Elliot Cunningham on 27/10/2018.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var isCurrentPosition: Bool
    @NSManaged public var name: String?
    @NSManaged public var geoloc: Geoloc?
    @NSManaged public var weather: NSSet?

}

// MARK: Generated accessors for weather
extension City {

    @objc(addWeatherObject:)
    @NSManaged public func addToWeather(_ value: Weather)

    @objc(removeWeatherObject:)
    @NSManaged public func removeFromWeather(_ value: Weather)

    @objc(addWeather:)
    @NSManaged public func addToWeather(_ values: NSSet)

    @objc(removeWeather:)
    @NSManaged public func removeFromWeather(_ values: NSSet)

}
