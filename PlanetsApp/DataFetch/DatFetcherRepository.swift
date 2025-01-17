//
//  DatFetcherRepository.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Combine

/// connect between remote and offline fetching based on network status
class PlanerDataFetcher: DataFetcher {
    typealias DataType = [Planet]

    private let offlineFetcher: OfflineDataFetcher<[Planet]>
    private let onlineFetcher: OnlineDataFetcher<PlanetResponse>
    private let localStorage: LocalStorage
    private let networkMonitor: NetworkMonitorProtocol

    init(offlineFetcher: OfflineDataFetcher<[Planet]>,
         onlineFetcher: OnlineDataFetcher<PlanetResponse>,
         localStorage: LocalStorage,
         networkMonitor: NetworkMonitorProtocol) {
        self.offlineFetcher = offlineFetcher
        self.onlineFetcher = onlineFetcher
        self.localStorage = localStorage
        self.networkMonitor = networkMonitor
    }

    func fetchData(path: String) -> AnyPublisher<[Planet], any Error> {
        //subscripe to isConnectedPublisher to recevie internet connection status
        networkMonitor.isConnectedPublisher
            .first()
            .flatMap {  [weak self] isConnected -> AnyPublisher<[Planet], any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "object is deinitialized", code: 0)).eraseToAnyPublisher() }
                //chek network connection
                if  isConnected {
                    //fetch online data
                    return onlineFetcher.fetchData(path: path)
                        .handleEvents(receiveOutput: { [weak self] planetResponse in
                            //save fetched result in offline storage
                            try? self?.localStorage.saveObject(planetResponse.results, forKey: path)
                        })
                        .map(\.results)
                        .eraseToAnyPublisher()
                } else {
                    //fetch offline data
                    return offlineFetcher.fetchData(path: path)
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
