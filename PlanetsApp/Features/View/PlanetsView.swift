//
//  PlanetsView.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import SwiftUI

struct PlanetsView: View {
    @ObservedObject var viewModel: PlanetsViewModel
    var body: some View {
        NavigationView {
            if let viewModelError = viewModel.errorMessage {
                //display the error for user allow them to retry the reuest
                VStack {
                    Text("Error: \(viewModelError)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Retry") {
                        viewModel.loadViewContent()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            } else if viewModel.planets.isEmpty {
                //request not fetched yet disply loading indicator
                ProgressView("Loading Planets...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                //Display fetched planets
                List(viewModel.planets, id: \.id) { item in
                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(.black)
                }
            }
        }.navigationTitle("Planets")
            .onAppear {
                viewModel.loadViewContent()
            }
    }
}

#Preview {
    let viewModel = PlanetsViewModel(dataFetcher: PlanetDataFetcher(offlineFetcher: OfflineDataFetcher(localStorage: UserDefaultsLocalStorage()), onlineFetcher: OnlineDataFetcher(networkService: URLSessionNetworkService()), localStorage: UserDefaultsLocalStorage(), networkMonitor: PlanetNetworkMonitor()))
    return PlanetsView(viewModel: viewModel)
}
