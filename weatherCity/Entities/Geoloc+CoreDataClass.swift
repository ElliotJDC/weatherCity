//
//  Geoloc+CoreDataClass.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Geoloc)
public class Geoloc: NSManagedObject {
    
    public class func geoloc(coordinate:Coordinate) -> Geoloc {
        let geoloc = Geoloc(context: CoreDataManager.sharedManager.persistentContainer.viewContext)
        geoloc.latitude = coordinate.latitude
        geoloc.longitude = coordinate.longitude
        
        return geoloc
    }

}
