//
//  PlanetsAppApp.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import SwiftUI

@main
struct PlanetsAppApp: App {
    @StateObject private var viewModel: PlanetsViewModel

    /// Initializes the app and sets up the dependency injection for the `PlanetsViewModel`.
    init() {
        let networkMonitor = PlanetNetworkMonitor()
        let localStorage = UserDefaultsLocalStorage()
        let offlineFetcher = OfflineDataFetcher(localStorage: localStorage)
        let onlineFetcher = OnlineDataFetcher(networkService: URLSessionNetworkService())
        let dataFetcher = DataFetcherRepository(
            offlineFetcher: offlineFetcher,
            onlineFetcher: onlineFetcher,
            localStorage: localStorage,
            networkMonitor: networkMonitor
        )

        _viewModel = StateObject(wrappedValue: PlanetsViewModel(dataFetcher: dataFetcher))
    }
    
    /// The main body of the app defining the app's UI hierarchy.
    var body: some Scene {
        WindowGroup {
            PlanetsView(viewModel: viewModel)
        }
    }
}
