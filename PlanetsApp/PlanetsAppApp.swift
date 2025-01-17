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

    init() {
        let networkMonitor = PlanetNetworkMonitor()
        let localStorage = UserDefaultsLocalStorage()
        let offlineFetcher = OfflineDataFetcher<[Planet]>(localStorage: localStorage)
        let onlineFetcher = OnlineDataFetcher<PlanetResponse>(networkService: URLSessionNetworkService())
        let dataFetcher = PlanetDataFetcher(
            offlineFetcher: offlineFetcher,
            onlineFetcher: onlineFetcher,
            localStorage: localStorage,
            networkMonitor: networkMonitor
        )

        _viewModel = StateObject(wrappedValue: PlanetsViewModel(dataFetcher: dataFetcher))
    }
    
    var body: some Scene {
        WindowGroup {
            PlanetsView(viewModel: viewModel)
        }
    }
}
