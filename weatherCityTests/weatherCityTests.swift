//
//  weatherCityTests.swift
//  weatherCityTests
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import XCTest
@testable import weatherCity

class weatherCityTests: XCTestCase {
    
    let context = CoreDataManager.sharedManager.persistentContainerForTest.viewContext
    var cityObjectForTest:City!
    var geolocForTest:Geoloc!
    var weatherForTest:Weather!
    

    override func setUp() {
        super.setUp()
        
        UserDefaults.standard.set(false, forKey: "kNeedReloadData")
        UserDefaults.standard.synchronize()
        
        cityObjectForTest = City(context: context)
        geolocForTest = Geoloc(context: context)
        weatherForTest = Weather(context: context)
        
        geolocForTest.latitude = 48.85341
        geolocForTest.longitude = 2.3488
        
        weatherForTest.nebulocite = 62.567
        weatherForTest.temperature = 9.543
        weatherForTest.pression = 100910.0
        weatherForTest.humidity = 70.0000
        weatherForTest.rain = 1.098
        weatherForTest.wind_rafale = 32.0
        weatherForTest.wind_average = 15.0
        weatherForTest.snow_alerte = false
        weatherForTest.for_date = Date() as NSDate
        weatherForTest.date_of_request = Date() as NSDate
        weatherForTest.geoloc = geolocForTest
        
        cityObjectForTest.name = "ParisTest"
        cityObjectForTest.geoloc = geolocForTest
        cityObjectForTest.addToWeather(weatherForTest)
        geolocForTest.city = cityObjectForTest
        weatherForTest.city = cityObjectForTest
    }

    override func tearDown() {
        super.tearDown()
        context.delete(cityObjectForTest)
        context.delete(weatherForTest)
        context.delete(geolocForTest)
    }


    func testCoreDataInit() {
        XCTAssertNotNil(cityObjectForTest)
        XCTAssertNotNil(weatherForTest)
        XCTAssertNotNil(geolocForTest)
    }
    
    func testDontReloadWeatherDataIfCityAlReadyExist() {
        
        let coordinate = Coordinate.init(latitude: 48.85341, longitude: 2.3488, findedDate: Date())
        let city = City.newCurrentCity(name: cityObjectForTest.name!, location: coordinate)
        let weather:Weather = city.weather!.anyObject()! as! Weather
        XCTAssertEqual(city, cityObjectForTest)
        XCTAssertEqual(weather, weatherForTest)
    }
    
    func testMakeNewCityIfDontKnowCity() {
        
        let coordinate = Coordinate.init(latitude: 48.85341, longitude: 2.3488, findedDate: Date())
        let city = City.newCurrentCity(name: "Paris2ForTest", location: coordinate)
        
        XCTAssertNotNil(city)
        XCTAssertNotEqual(city, cityObjectForTest)
    }
    
    func testRemoveAllWeatherRemoveAllWeather() {
        Weather.removeAllWeather(city: cityObjectForTest)
        
        XCTAssertNil(cityObjectForTest.weather?.anyObject())
    }
    
    func testCreateNewWeatherFromDictReturnNilIfBadDictDictAndNotNilIfDict() {
        let weather = Weather.createNewWeather(dict: ["test":"test"], city: cityObjectForTest, date: Date())
        XCTAssertNil(weather)
        
        let dict = [
            "temperature" : ["sol" : 22.7],
            "humidite": ["2m": 10.98],
            "vent_rafales": ["10m": 10],
            "nebulosite": ["totale": 10],
            "vent_moyen": ["10m": 3],
            "pluie": 0.00,
            "risque_neige": "non",
            "pression": ["niveau_de_la_mer": 10000]
            ] as [String : Any]
        
        let weather2 = Weather.createNewWeather(dict: dict, city: cityObjectForTest, date: Date())
        
        XCTAssertNotNil(weather2)
    }
    
    func testCityWeatherChangeIfGetWeatherFuncisCall() {
        let weatherData = cityObjectForTest.weather?.anyObject() as! Weather
        
        let dict = [
            "temperature" : ["sol" : 22.7],
            "humidite": ["2m": 10.98],
            "vent_rafales": ["10m": 10],
            "nebulosite": ["totale": 10],
            "vent_moyen": ["10m": 3],
            "pluie": 0.00,
            "risque_neige": "non",
            "pression": ["niveau_de_la_mer": 10000]
            ] as [String : Any]
        
        let weatherData2 = Weather.createNewWeather(dict: dict, city: cityObjectForTest, date: Date())
        
        XCTAssertNotEqual(weatherData, weatherData2)
    }
    
}
