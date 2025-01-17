//
//  DataFetcher.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

protocol DataFetcher {

    /// Fetch data from the source.
    /// - Returns: A `Combine` publisher that emits the fetched data or an error.
    func fetchData<T: Codable>(path: String, _ type: T.Type) -> AnyPublisher<T, Error>
}
