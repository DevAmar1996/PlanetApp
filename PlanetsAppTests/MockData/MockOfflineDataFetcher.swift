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

    override func fetchData(path: String) -> AnyPublisher<T, Error> {
        guard let data = mockData else {
            return Fail(error: OfflineError.noDataAvailable).eraseToAnyPublisher()
        }
        return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
