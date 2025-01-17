//
//  MockOfflineDataFetcher.swift
//  PlanetsAppTests
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Combine

class MockDataFetcher: DataFetcher {

    var mockData: (any Encodable)?
    var isOffline: Bool = false

    func fetchData<T: Encodable>(path: String, _ type: T.Type) -> AnyPublisher<T, Error> {
        guard let data = mockData as? T else {
            if isOffline {
                return Fail(error: OfflineError.noDataAvailable).eraseToAnyPublisher()
            } else {
                return Fail(error: NetworkError.requestFailed(statusCode: 500, message: "Data unavailable")).eraseToAnyPublisher()
            }
        }
        return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
