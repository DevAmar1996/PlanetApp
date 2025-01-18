//
//  LocalStorageProtocol.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation

/// A protocol for managing local storage operations, including saving and retrieving `Codable` objects.
protocol LocalStorage {
    /// Save a decodable object to local storage.
    /// - Parameters:
    ///   - object: The object to be saved, conforming to `Encodable`.
    ///   - key: A unique key for storing the object.
    /// - Throws: throw error in case of saving fail.
    func saveObject<T: Encodable>(_ object: T, forKey key: String) throws
    
    /// Retrieve a decodable object from local storage.
    /// - Parameters:
    ///   - key: The unique key associated with the stored object.
    ///   - type: The type of the object to be retrieved.
    /// - Throws: throw error in case of fetcing fail.
    /// - Returns: The decoded object of the specified type, or `nil` if not found or decoding fails.
    func retrieveObject<T: Decodable>(forKey key: String, as type: T.Type) throws -> T?
}

/// `OfflineError` represents errors related to offline storage operations.
enum OfflineError: Error, LocalizedError {
    case noDataAvailable
    case failToSave
    
    var errorDescription: String? {
        switch self {
        case .noDataAvailable:
            return "No data available."
        case .failToSave:
            return "Fail to Save data."
        }
    }
}
