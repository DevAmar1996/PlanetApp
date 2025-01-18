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
/// The `DataFetcherRepository` coordinates between online and offline fetchers, saving
/// online data to local storage when connected to the internet, and falling back to
/// offline data when no internet connection is available.
class DataFetcherRepository: DataFetcher {
    private let offlineFetcher: DataFetcher
    private let onlineFetcher: DataFetcher
    private let localStorage: LocalStorage
    private let networkMonitor: NetworkMonitor
    
    init(offlineFetcher: DataFetcher,
         onlineFetcher: DataFetcher,
         localStorage: LocalStorage,
         networkMonitor: NetworkMonitor) {
        self.offlineFetcher = offlineFetcher
        self.onlineFetcher = onlineFetcher
        self.localStorage = localStorage
        self.networkMonitor = networkMonitor
    }
    
    func fetchData<T: Codable>(path: String, _ type: T.Type) -> AnyPublisher<T, Error> {
        networkMonitor.isConnectedPublisher
            .first()
            .flatMap { [weak self] isConnected in
                self?.fetchBasedOnNetworkStatus(isConnected: isConnected, path: path, type: type) ??
                Fail(error: NSError(domain: "DataFetcherRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Object deinitialized"]))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // Determine network connectivity and fetch data accordingly.
    private func fetchBasedOnNetworkStatus<T: Codable>(isConnected: Bool, path: String, type: T.Type) -> AnyPublisher<T, Error> {
        if isConnected {
            return fetchOnlineAndCache(path: path, type: type)
        } else {
            return fetchOffline(path: path, type: type)
        }
    }
    
    private func fetchOnlineAndCache<T: Codable>(path: String, type: T.Type) -> AnyPublisher<T, Error> {
        onlineFetcher.fetchData(path: path, type)
            .handleEvents(receiveOutput: { [weak self] data in
                self?.saveToLocalStorage(data: data, forKey: path)
            })
            .eraseToAnyPublisher()
    }
    
    private func fetchOffline<T: Codable>(path: String, type: T.Type) -> AnyPublisher<T, Error> {
        offlineFetcher.fetchData(path: path, type)
            .eraseToAnyPublisher()
    }
    
    private func saveToLocalStorage<T: Codable>(data: T, forKey key: String) {
        do {
            try localStorage.saveObject(data, forKey: key)
        } catch {
            print("Failed to save data to local storage: \(error)")
        }
    }
}
