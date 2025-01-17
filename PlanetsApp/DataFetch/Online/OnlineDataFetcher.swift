//
//  OnlineDataFetcher.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

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
