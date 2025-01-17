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
        if let data = try? localStorage.retrieveObject(forKey: path, as: T.self) {
            //return the data if found
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: OfflineError.noDataAvailable)
                .eraseToAnyPublisher()
        }
    }
}
