//
//  OnlineDataFetcher.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

class OnlineDataFetcher<T: Codable>: DataFetcher {
    typealias DataType = T

    var networkService: NetworkService

    private var cancellables = Set<AnyCancellable>()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchData(path: String) -> AnyPublisher<T, any Error> {
        // Make a network request using the provided path and HTTP GET method.
        networkService.makeRequest(url: path,
                                      httpMethod: .get)
            .eraseToAnyPublisher()
    }
}
