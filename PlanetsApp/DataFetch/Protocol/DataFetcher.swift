//
//  DataFetcher.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

/// A protocol defining the contract for fetching data from a source.
/// Used to abstract online and offline fetching logic.
protocol DataFetcher {
    
    /// Fetch data from the source.
    /// - Parameters:
    ///   - path: The path or key to fetch the data from.
    ///   - type: The expected type of the returned data.
    /// - Returns: A `Combine` publisher that emits the fetched data or an error.
    func fetchData<T: Codable>(path: String, _ type: T.Type) -> AnyPublisher<T, Error>
}
