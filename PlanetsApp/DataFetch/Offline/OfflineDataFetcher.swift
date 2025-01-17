//
//  OfflineDataFetcher.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

class OfflineDataFetcher<T: Decodable>: DataFetcher {

    typealias DataType = T
    let localStorage: LocalStorage

    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }

    func fetchData(path: String) -> AnyPublisher<T, any Error> {
        // Attempt to retrieve the data from local storage.
        if let data = try? localStorage.retrieveObject(forKey: path, as: T.self) {
            // Return the data as a Combine publisher using `Just`.
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            // Return a failure publisher if no data is found.
            return Fail(error: OfflineError.noDataAvailable)
                .eraseToAnyPublisher()
        }
    }
}
