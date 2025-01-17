//
//  OfflineDataFetcher.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

class OfflineDataFetcher: DataFetcher {
    let localStorage: LocalStorage

    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }
    
    func fetchData<T: Codable>(path: String, _ type: T.Type) -> AnyPublisher<T, Error> {
        // Attempt to retrieve the data from local storage.
        if let data = try? localStorage.retrieveObject(forKey: path,
                                                       as: type) {
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
