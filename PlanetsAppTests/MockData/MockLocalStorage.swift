//
//  MockLocalStorage.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation

class MockLocalStorage: LocalStorage {
    private var storage: [String: Data] = [:]

    //simulate saving using dictionary
    func saveObject<T: Encodable>(_ object: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            storage[key] = data
        } catch {
            throw OfflineError.failToSave
        }
    }

    //simulate retriving using dictionary
    func retrieveObject<T: Decodable>(forKey key: String, as type: T.Type) throws -> T? {
        guard let data = storage[key] else {
            throw OfflineError.noDataAvailable
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw OfflineError.noDataAvailable
        }
    }
}
