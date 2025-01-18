//
//  PlanetsView.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import SwiftUI

struct PlanetsView: View {

    @ObservedObject var viewModel: PlanetsViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        Group {
         #if os(macOS)
            macOSView
          #else
            iOSView
          #endif
        }
        .onAppear {
            viewModel.loadViewContent()
        }
    }

    private var macOSView: some View {
        NavigationView {
            List {
                ForEach(viewModel.planets, id: \.id) { planet in
                    HStack {
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                        Text(planet.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
            }
            .frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity)
            .navigationTitle("Planets")
        }
    }

    private var iOSView: some View {
        NavigationView {
            Group {
                if let viewModelError = viewModel.errorMessage {
                    //display the error for user allow them to retry the request.
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
                    //request not fetched yet disply loading indicator.
                    ProgressView("Loading Planets...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    contentList
                }
            }.navigationTitle("Planets")
                .navigationBarTitleDisplayMode(.large)

        }                .navigationViewStyle(StackNavigationViewStyle())

    }

    // MARK: - Content List
    private var contentList: some View {
        Group {
            if horizontalSizeClass == .regular {
                // Grid layout for iPads.
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 180))], spacing: 16) {
                        ForEach(viewModel.planets, id: \.id) { planet in
                            PlanetCardView(planet: planet)
                                .padding()
                        }
                    }
                    .padding()
                }
            } else {
                // List layout for iPhones.
                List(viewModel.planets, id: \.id) { planet in
                    Text(planet.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}

struct PlanetCardView: View {
    let planet: Planet

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding()
            Text(planet.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding()
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    let viewModel = PlanetsViewModel(dataFetcher: DataFetcherRepository(offlineFetcher: OfflineDataFetcher(localStorage: UserDefaultsLocalStorage()), onlineFetcher: OnlineDataFetcher(networkService: URLSessionNetworkService()), localStorage: UserDefaultsLocalStorage(), networkMonitor: PlanetNetworkMonitor()))
    return PlanetsView(viewModel: viewModel)
}
