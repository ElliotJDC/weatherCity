//
//  WeatherApi.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import Foundation
import Alamofire
import Moya

let authToken:String = "ARsEEwB%2BASMHKgM0AXcBKFkxAjcLfQYhBHgFZgtuBXgFbgRlUzNTNQJsAXwEKwI0VHkEZwA7U2MFbgtzCnhXNgFrBGgAawFmB2gDZgEuASpZdwJjCysGIQRuBWILeAVgBWUEflMyUzMCaQF9BDYCPlR4BHsAPlNuBWILbApiVzIBYwRoAGcBYgd3A34BNAFnWT4CYQs1BmwENQVjC2cFYQVhBGNTOVM4AnMBZAQxAjdUZQRgAD1TawVnC3MKeFdNAREEfQAjASEHPQMnASwBYFk0AjY%3D"

enum WeatherApi {
    case getWeatherJSON(String)
    case getWeatherCSV(String)
    case getWeatherXML(String)
}

extension WeatherApi : TargetType {
    var sampleData: Data {
        return "This function is never call".data(using: String.Encoding.utf8)!
    }
    
    
    var method: Moya.Method {
        switch self {
        case .getWeatherJSON(_):
            return .get
        case .getWeatherCSV(_):
            return .get
        case .getWeatherXML(_):
            return .get
        }
    }
    
    var headers:[String:String]? {
        
        switch self {
            
        case .getWeatherJSON:
            return ["content-type" : "application/json"]
        case .getWeatherCSV:
            return ["content-type" : "application/csv"]
        case .getWeatherXML:
            return ["content-type" : "application/xml"]
        }
        
    }
    
    
    
    var baseURL:URL {
        return URL(string: "http://www.infoclimat.fr/public-api/gfs/")!
    }
    
    var path:String {
        switch self {
        case .getWeatherJSON:
            return "json"
        case .getWeatherCSV:
            return "csv"
        case .getWeatherXML:
            return "xml"
        }
    }
    
    var params:[String:String]! {
        switch self {
        case .getWeatherJSON(let locationString):
            return [
                "_ll" : locationString,
                "_auth" : authToken,
                "_c" : "b9731b25376511fe1906248f08b0ab32"
            ]
        case .getWeatherCSV(let locationString):
            return [
                "_ll" : locationString,
                "_auth" : authToken,
                "_c" : "b9731b25376511fe1906248f08b0ab32"
            ]
        case .getWeatherXML(let locationString):
            return [
                "_ll" : locationString,
                "_auth" : authToken,
                "_c" : "b9731b25376511fe1906248f08b0ab32"
            ]
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: self.params, encoding: URLEncoding())
    }
    
}

extension WeatherApi {
    
    public func makeLocationString(latitude:Double, longitude:Double) -> String {
        let latString = String(latitude)
        let lonString = String(longitude)
        
        return latString + "," + lonString
    }
    
    public func url(_ route:TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
    
}
