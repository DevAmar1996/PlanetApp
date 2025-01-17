//
//  MockOfflineDataFetcher.swift
//  PlanetsAppTests
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Combine

class MockOfflineDataFetcher<T: Decodable>: OfflineDataFetcher<T> {
    
    var mockData: T?
    var shouldReturnError: Bool = false

    override func fetchData(path: String) -> AnyPublisher<T, Error> {
        if shouldReturnError {
            return Fail(error: OfflineError.noDataAvailable).eraseToAnyPublisher()
        } else if let data = mockData {
            return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: OfflineError.noDataAvailable).eraseToAnyPublisher()
        }
    }
}
