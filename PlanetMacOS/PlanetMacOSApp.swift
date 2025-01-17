//
//  PlanetMacOSApp.swift
//  PlanetMacOS
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import SwiftUI

@main
struct PlanetMacOSApp: App {
    @StateObject private var viewModel: PlanetsViewModel

    init() {
        let localStorage = UserDefaultsLocalStorage()
        let networkMonitor = NetworkMonitor()
        let offlineFetcher = OfflineDataFetcher<[Planet]>(localStorage: localStorage)
        let onlineFetcher = OnlineDataFetcher<PlanetResponse>(networkService: URLSessionNetworkService())
        let dataFetcher = PlanerDataFetcher(
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
