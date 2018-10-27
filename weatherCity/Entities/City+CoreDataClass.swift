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
import Alamofire

@objc(City)
public class City: NSManagedObject {
    
    // check if city exist if dosn't exist return nil
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
    
    // delete the current City
    // this function is call is GeolocMLanager find auto a new city
    public class func removeCurrentCity() {
        let request:NSFetchRequest = City.fetchRequest()
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        do{
            
            let citys:[City] = try context.fetch(request)
            for aCity in citys {
                if aCity.isCurrentPosition {
                    aCity.isCurrentPosition = false
                }
            }
            
            CoreDataManager.sharedManager.saveContext()
        }
        catch let error {
            print("error executing city fetch request", error)
        }
    }
    
    
    // check if city exist else create a city and get weather city of the data
    public class func newCurrentCity(name:String, location:Coordinate) -> City {
        var city = City.getCity(name: name)
        
        if nil == city {
            city = City(context: CoreDataManager.sharedManager.persistentContainer.viewContext)
            city?.name = name
            self.removeCurrentCity()
            city?.isCurrentPosition = true
            
            
            let geoloc = Geoloc.geoloc(coordinate: location)
            geoloc.city = city
            city?.geoloc = geoloc
            
            Weather.fetchDataWeather(coordonate: location, city: city!)
            
            CoreDataManager.sharedManager.saveContext()
        }
        
        if UserDefaults.standard.bool(forKey: "kNeedReloadData") {
            if !Connectivity.isConnectedToInternet {
                Weather.fetchDataWeather(coordonate: location, city: city!)
            }
        }
        
        return city!
    }
    
    
    // create new city and get data weather of the city
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
    
    
    // reload all weather data for all city
    // is call auto after 2 hour
    public class func reloadWeatherDataIfNeeded() -> Void {
        
        // check if have internet connection else return
        
        if !Connectivity.isConnectedToInternet {
            return
        }
        
        let request:NSFetchRequest = City.fetchRequest()
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        do{
            
            let citys:[City] = try context.fetch(request)
            for aCity in citys {
                guard let geoloc = aCity.geoloc else { continue }
                let location = Coordinate.init(latitude: geoloc.latitude, longitude: geoloc.longitude, findedDate: Date())
                Weather.fetchDataWeather(coordonate: location, city: aCity)
            }
            
            CoreDataManager.sharedManager.saveContext()
        }
        catch let error {
            print("error executing city fetch request", error)
        }
    }

}


// simple struct return true if connected to internet else return false
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
