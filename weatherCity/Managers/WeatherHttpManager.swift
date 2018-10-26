//
//  WeatherHttpManager.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import Result
import ObjectMapper

class WeatherHttpManager: NSObject {
    
    var weatherProvider:MoyaProvider<WeatherApi>!
    
    
    let requestClosure = { (endpoint: Moya.Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            // Modify the request however you like.
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    var endpointClosure = { (target: WeatherApi) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        
        let endpoint: Endpoint = Endpoint(url: url, sampleResponseClosure: { () -> EndpointSampleResponse in
            .networkResponse(200, target.sampleData)
        }, method: target.method, task: target.task, httpHeaderFields: target.headers)
        
        return endpoint
    }
    
    
    override init() {
        super.init()
        weatherProvider = MoyaProvider<WeatherApi>(endpointClosure: endpointClosure, requestClosure: requestClosure)
    }
    
    
    func requestApi(_ target:WeatherApi,
                    success: @escaping (_ data: Data?, _ statusCode: Int?, _ response: URLResponse?) -> Void,
                    failure: @escaping (_ errors: WeatherError?, _ statusCode: Int?, _ error: MoyaError?) -> Void) -> Void {
        
        weatherProvider.request(target) { (result) in
            switch result {
            case .success(let response):
                success(response.data, response.statusCode, response.response)
                
            case .failure(let error):
                self.handleFailure(error.response?.data, statusCode: error._code, error: error, failure: failure)
            }
        }
        
    }
    
    func handleFailure(_ errors: Data?, statusCode: Int?, error: MoyaError?, failure: (_ errors: WeatherError?, _ statusCode: Int?, _ error: MoyaError?) -> Void) {
        if let data = errors {
            let json = String(data: data, encoding: String.Encoding.utf8)
            let errors = Mapper<WeatherError>().mapSet(JSONString: json!)
            
            failure(errors?.first, statusCode, error)
        }
        else {
            failure(nil, statusCode, error)
        }
    }
    
    func getDataMeteoForCoordinate(latitude:Double, longitude:Double, completion:@escaping(_ weatherDic:[String:Any]?) -> Void) -> Void {
        
        let stringCoordinate = String(latitude) + "," + String(longitude)
        self.requestApi(.getWeatherJSON(stringCoordinate), success: { (data, status, response) in
            
            guard let data = data,
                let jsonString = String(data: data, encoding: String.Encoding.utf8),
                let dictionary = jsonString.convertStringToDictionary() else {
                    
                completion(nil)
                return
            }
            
            print(dictionary)
            completion(dictionary)
            
        }) { (weatherError, status, error) in
            guard let weatherError = weatherError,
                let error = error else {
                    
                    print("error get meto")
                    completion(nil)
                    return
            }
            
            print("error get meteo", error, weatherError)
            completion(nil)
        }
    }

}

extension String {
    func convertStringToDictionary() -> [String: AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}







class WeatherError: NSObject, Mappable {
    var errors: Array<Dictionary<String, Dictionary<String, String>>>?
    
    override init() {
        super.init()
    }
    
    // MARK: - Mapping
    
    required init?(map: ObjectMapper.Map) {
        super.init()
        self.mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        self.errors  <- map["errors"]
    }
}





