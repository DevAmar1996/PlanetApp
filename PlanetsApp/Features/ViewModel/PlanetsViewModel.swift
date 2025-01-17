//
//  PlanetsViewModel.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

// Protocol to define the basic requirements for a PlanetsViewModel.
protocol PlanetsViewModelProtocol {
    var networkService: NetworkService {get set}
    func loadViewContent()
}

/// A ViewModel responsible for managing the data and state of the Planets view.
/// Fetches planet data using the `PlanetDataFetcher` and updates the published properties.
class PlanetsViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var planets: [Planet] = []
    @Published var errorMessage: String?

    // MARK: - Dependencies
    var dataFetcher: DataFetcher

    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    /// Initializes the `PlanetsViewModel` with a given data fetcher.
    ///
    /// - Parameter dataFetcher: An instance of `PlanetDataFetcher` for fetching planet data.
    init(dataFetcher: DataFetcher) {
        self.dataFetcher = dataFetcher
    }

    // MARK: - Public Methods

    /// Loads the content for the view by fetching the planets.
    func loadViewContent() {
        getPlanets()
    }

    // MARK: - Private Methods

    /// Fetches the planets from the data fetcher and updates the published properties.
    private func getPlanets() {
        dataFetcher.fetchData(
            path: APIConstants.BASE_URL, PlanetResponse.self)
        .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            case .finished:
                break
            }
        } receiveValue: { [weak self] (planets: PlanetResponse) in
            print("I got the planets ", planets.results)
            self?.planets = planets.results
        }.store(in: &cancellables)
    }
}
