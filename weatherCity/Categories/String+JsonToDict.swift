//
//  String+JsonToDict.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 28/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import Foundation

// extension for string class to transform a JSON string into Dictionary

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
