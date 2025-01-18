//
//  OnlineDataFetcher.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

/// Fetches data from a remote source using a `NetworkService`.
/// Performs HTTP GET requests and returns a Combine publisher with the decoded response or an error.
class OnlineDataFetcher: DataFetcher {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchData<T: Decodable>(path: String, _ type: T.Type) -> AnyPublisher<T, Error> {
        // Make a network request using the provided path and HTTP GET method.
        networkService.makeRequest(url: path, httpMethod: .get)
            .eraseToAnyPublisher()
    }
}
