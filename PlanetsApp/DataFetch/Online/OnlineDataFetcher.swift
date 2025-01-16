//
//  OnlineDataFetcher.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine


// solid
// single responsability
// open for extends close for modification
// l
// integrace segragation -> Protocol
// depndency inverstion -> A -> B, C -> D

// viewModel -> Repoisotry -> remotedata source, local data source

class OnlineDataFetcher<T: Codable>: DataFetcher {
    typealias DataType = T

    var networkService: NetworkService

    private var cancellables = Set<AnyCancellable>()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchData(path: String) -> AnyPublisher<T, any Error> {
        networkService.makeRequest(url: path,
                                      httpMethod: .get)
            .eraseToAnyPublisher()
    }
}
