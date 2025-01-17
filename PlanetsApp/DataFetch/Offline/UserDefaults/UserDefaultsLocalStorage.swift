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
            let data = try encoder.encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            throw OfflineError.failToSave
        }
    }
    
    func retrieveObject<T>(forKey key: String, as type: T.Type) throws -> T? where T : Decodable {
        do {
            let decoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: key) else {
                throw OfflineError.noDataAvailable }
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to fetch object for key \(key): \(error)")
            throw OfflineError.noDataAvailable 
        }
    }

}
