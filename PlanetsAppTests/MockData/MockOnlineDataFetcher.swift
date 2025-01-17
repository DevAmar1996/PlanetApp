//
//  MockOnlineDataFetcher.swift
//  PlanetsAppTests
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Combine

class MockOnlineDataFetcher<T: Codable>: OnlineDataFetcher<T> {
    var mockData: T?
    
    override func fetchData(path: String) -> AnyPublisher<T, Error> {
       if let data = mockData {
            return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
}
