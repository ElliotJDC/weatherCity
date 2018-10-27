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

let authToken = "?_auth=ARsEEwB%2BASMHKgM0AXcBKFkxAjcLfQYhBHgFZgtuBXgFbgRlUzNTNQJsAXwEKwI0VHkEZwA7U2MFbgtzCnhXNgFrBGgAawFmB2gDZgEuASpZdwJjCysGIQRuBWILeAVgBWUEflMyUzMCaQF9BDYCPlR4BHsAPlNuBWILbApiVzIBYwRoAGcBYgd3A34BNAFnWT4CYQs1BmwENQVjC2cFYQVhBGNTOVM4AnMBZAQxAjdUZQRgAD1TawVnC3MKeFdNAREEfQAjASEHPQMnASwBYFk0AjY%3D&_c=b9731b25376511fe1906248f08b0ab32&_ll="


// Weather APi is a simple enum with mutiple swith for get good url

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
            return ["content-type" : "application/x-www-form-urlencoded", "charset" : "utf-8"]
        case .getWeatherCSV:
            return ["content-type" : "application/csv"]
        case .getWeatherXML:
            return ["content-type" : "application/xml"]
        }
        
    }
    
    
    
    var baseURL:URL {
        return URL(string: "https://www.infoclimat.fr/public-api/gfs/")!
    }
    
    var path:String {
        switch self {
        case .getWeatherJSON(let coordinateString):
            return "json" + authToken + coordinateString
        case .getWeatherCSV(let coordinateString):
            return "csv" + authToken + coordinateString
        case .getWeatherXML(let coordinateString):
            return "xml" + authToken + coordinateString
        }
    }
    
    
    // params is not use because Moya encode url ass url but we need to conserve the utf8 format
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
    
    // return an Alamofire fire Task
    var task: Task {
        return .requestPlain
    }
    
}

extension WeatherApi {
    
    public func makeLocationString(latitude:Double, longitude:Double) -> String {
        let latString = String(latitude)
        let lonString = String(longitude)
        
        return latString + "," + lonString
    }
    
    public func url(_ route:TargetType) -> String {
        return route.baseURL.absoluteString + route.path
    }
    
}
