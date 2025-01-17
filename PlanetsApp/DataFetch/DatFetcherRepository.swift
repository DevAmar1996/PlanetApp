//
//  DatFetcherRepository.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Combine

/// A repository that connects remote (online) and offline data fetching mechanisms
/// based on the current network status.
///
/// The `PlanetDataFetcher` coordinates between online and offline fetchers, saving
/// online data to local storage when connected to the internet, and falling back to
/// offline data when no internet connection is available.
class PlanetDataFetcher: DataFetcher {
    typealias DataType = [Planet]

    private let offlineFetcher: OfflineDataFetcher<[Planet]>
    private let onlineFetcher: OnlineDataFetcher<PlanetResponse>
    private let localStorage: LocalStorage
    private let networkMonitor: NetworkMonitor

    init(offlineFetcher: OfflineDataFetcher<[Planet]>,
         onlineFetcher: OnlineDataFetcher<PlanetResponse>,
         localStorage: LocalStorage,
         networkMonitor: NetworkMonitor) {
        self.offlineFetcher = offlineFetcher
        self.onlineFetcher = onlineFetcher
        self.localStorage = localStorage
        self.networkMonitor = networkMonitor
    }

    func fetchData(path: String) -> AnyPublisher<[Planet], any Error> {
        //subscripe to isConnectedPublisher to check the current internet connection status
        networkMonitor.isConnectedPublisher
        // take the first value which is boolean indicate if it is connected or not
            .first()
            .flatMap {  [weak self] isConnected -> AnyPublisher<[Planet], any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "object is deinitialized", code: 0)).eraseToAnyPublisher() }
                //chek if the device connected to internet
                if  isConnected {
                    // Fetch data online and save it to local storage.
                    return onlineFetcher.fetchData(path: path)
                        .handleEvents(receiveOutput: { [weak self] planetResponse in
                            // Attempt to save the fetched data to offline storage.
                            try? self?.localStorage.saveObject(planetResponse.results, forKey: path)
                        })
                       // Extract the array of planets from the response.
                        .map(\.results)
                        .eraseToAnyPublisher()
                } else {
                    // Fetch data from offline storage when there is no internet connection.
                    return offlineFetcher.fetchData(path: path)
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
