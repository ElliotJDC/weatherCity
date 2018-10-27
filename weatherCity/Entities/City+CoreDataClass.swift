//
//  City+CoreDataClass.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//
//

import Foundation
import CoreData

@objc(City)
public class City: NSManagedObject {
    
    public class func getCity(name:String) -> City? {
        let request:NSFetchRequest = City.fetchRequest()
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        do{
            
            let citys:[City] = try context.fetch(request)
            for aCity in citys {
                guard let cityName = aCity.name else { continue }
                if cityName == name { return aCity }
            }
        }
        catch let error {
            print("error executing city fetch request", error)
            return nil
        }
        
        
        
        return nil
    }
    
    public class func city(name:String, location:Coordinate) -> City {
        var city = City.getCity(name: name)
        
        if nil == city {
            city = City(context: CoreDataManager.sharedManager.persistentContainer.viewContext)
            city?.name = name
            city?.isCurrentPosition = true
            
            let geoloc = Geoloc.geoloc(coordinate: location)
            geoloc.city = city
            city?.geoloc = geoloc
            
            Weather.fetchDataWeather(coordonate: location, city: city!)
            
            CoreDataManager.sharedManager.saveContext()
        }
        
        return city!
    }
    
    public class func createNewCity(cityName:String, location:Coordinate) -> City {
        let city = City(context: CoreDataManager.sharedManager.persistentContainer.viewContext)
        city.name = cityName
        city.isCurrentPosition = false
        
        let geoloc = Geoloc.geoloc(coordinate: location)
        geoloc.city = city
        city.geoloc = geoloc
        
        Weather.fetchDataWeather(coordonate: location, city: city)
        
        CoreDataManager.sharedManager.saveContext()
        
        return city
    }

}
