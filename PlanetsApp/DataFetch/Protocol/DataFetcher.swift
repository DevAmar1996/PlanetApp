//
//  DataFetcher.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

protocol DataFetcher {
    associatedtype DataType: Decodable

    /// Fetch data from the source.
    /// - Returns: A `Combine` publisher that emits the fetched data or an error.
    func fetchData(path: String) -> AnyPublisher<DataType, Error>
}



