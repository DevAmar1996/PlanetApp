//
//  PlanetsViewModel.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

protocol PlanetsViewModelProtocol {
    var networkService: NetworkService {get set}
    func loadViewContent()
}

class PlanetsViewModel: ObservableObject {

    @Published var planets: [Planet] = []
    @Published var errorMessage: String? // For displaying errors

    var dataFetcher: PlanetDataFetcher
    private var cancellables = Set<AnyCancellable>() // For Combine subscriptions

    init(dataFetcher: PlanetDataFetcher) {
        self.dataFetcher = dataFetcher
    }

    func loadViewContent() {
        getPlanets()
    }

    private func getPlanets() {
        dataFetcher.fetchData(
            path: APIConstants.BASEURL)
        .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            case .finished:
                break
            }
        } receiveValue: { [weak self] planets in
            print("I got the planets ", planets)
            self?.planets = planets
        }.store(in: &cancellables)
    }

}
