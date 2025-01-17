//
//  UserDfaultsLocalStorage.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation

class UserDefaultsLocalStorage: LocalStorage {
    func saveObject<T: Encodable>(_ object: T, forKey key: String) throws {
        do {
            let encoder = JSONEncoder()
            //encode data
            let data = try encoder.encode(object)
            //save it in user defaults
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            //throw an exception if data failed to save
            throw OfflineError.failToSave
        }
    }
    
    func retrieveObject<T>(forKey key: String, as type: T.Type) throws -> T? where T : Decodable {
        do {
            let decoder = JSONDecoder()
            //fetch data from user defaults
            guard let data = UserDefaults.standard.data(forKey: key) else {
                //throw an exception if data not exist
                throw OfflineError.noDataAvailable
            }
            // return decoded fetched data
            return try decoder.decode(T.self, from: data)
        } catch {
            //throw an exception if data failed to retrive
            print("Failed to fetch object for key \(key): \(error)")
            throw OfflineError.noDataAvailable 
        }
    }

}
