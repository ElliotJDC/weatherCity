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
    
    
    // fetch weather data check if result is good for all weather by time create new weather object
    public class func fetchDataWeather(coordonate:Coordinate, city:City) -> Void {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.removeAllWeather(city:city)
        WeatherHttpManager.sharedManager.getDataMeteoForCoordinate(latitude: coordonate.latitude, longitude: coordonate.longitude) { (dictionary) in
            guard let dict = dictionary else {
                return
            }
            
            for key:String in dict.keys {
                guard let weatherDict = dict[key] as? [String:Any] else {
                    continue
                }
                
                let date = dateFormatter.date(from: key)
                if let date = date {
                    if (date.timeIntervalSinceNow.sign == .plus) {
                        _ = self.createNewWeather(dict: weatherDict, city: city, date: date)
                    }
                }
            }
            
            CoreDataManager.sharedManager.saveContext()
            
        }
    }
    
    // func for create new weather from a dict func check all data before create object
    
    public class func createNewWeather(dict:[String:Any], city:City, date:Date) -> Weather? {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        let weather = Weather(context: context)
        
        print(dict)
        
        guard let temperatures = dict["temperature"] as? [String:Any] else {  return nil }
        guard let temperature = temperatures["sol"] as? NSNumber else { return nil }
        guard let humiditys = dict["humidite"] as? [String:Any] else { return nil }
        guard let humidity = humiditys["2m"] as? NSNumber else { return nil }
        guard let windRafales = dict["vent_rafales"] as? [String:Any] else { return nil }
        guard let windRafale = windRafales["10m"] as? NSNumber else { return nil }
        guard let nebulosites = dict["nebulosite"] as? [String:Any] else { return nil }
        guard let nebulosite = nebulosites["totale"] as? NSNumber else { return nil }
        guard let windAverages = dict["vent_moyen"] as? [String:Any] else { return nil}
        guard let windAverage = windAverages["10m"] as? NSNumber else { return nil }
        guard let rain = dict["pluie"] as? NSNumber else { return nil }
        guard let stringBoolSnow = dict["risque_neige"] as? String else { return nil }
        guard let pressions = dict["pression"] as? [String:Any] else { return nil }
        guard let pression = pressions["niveau_de_la_mer"] as? NSNumber else { return nil }
        
        weather.nebulocite = nebulosite.floatValue
        weather.temperature = temperature.floatValue - 273.15
        weather.pression = pression.floatValue
        weather.rain = rain.floatValue
        weather.humidity = humidity.floatValue
        weather.wind_average = windAverage.floatValue
        weather.wind_rafale = windRafale.floatValue
        weather.snow_alerte = (stringBoolSnow == "non") ? false : true
        weather.date_of_request = NSDate()
        weather.for_date = date as NSDate
        weather.city = city
        weather.geoloc = city.geoloc
        
        city.addToWeather(weather)
        
        return weather
    }
    
    // func for remove all weather data for a specified city
    class func removeAllWeather(city:City) {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request:NSFetchRequest = Weather.fetchRequest()
        
        do{
            let weathers:[Weather] = try context.fetch(request)
            for weather in weathers {
                if weather.city == city {
                    city.removeFromWeather(weather)
                    context.delete(weather)
                }
            }
        }
        catch let error {
            print("error trying to faetch weather", error)
        }
        
    }
    
    
    //    func for get good weather in weather array
    // function check date for get the good weather
    class func findGoodWeatherForDate(date:Date, weathers:[Weather]) -> Weather? {
        var intervalBetwenDate:TimeInterval?
        var finalWeather:Weather?
        
        for weather in weathers {
            if weather.for_date?.timeIntervalSinceNow.sign == .plus {
                if intervalBetwenDate == nil {
                    intervalBetwenDate = weather.for_date?.timeIntervalSinceNow
                    finalWeather = weather
                }
                else {
                    guard let interval = weather.for_date?.timeIntervalSinceNow else { continue }
                    guard let intervalSave = intervalBetwenDate else { continue }
                    if intervalSave > interval {
                        finalWeather = weather
                        intervalBetwenDate = weather.for_date?.timeIntervalSinceNow
                    }
                }
            }
        }
        
        return finalWeather
    }
    
}
