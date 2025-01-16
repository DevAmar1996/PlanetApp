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

    var networkService: NetworkService
    private var cancellables = Set<AnyCancellable>() // For Combine subscriptions

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func loadViewContent() {
        getPlanets()
    }

    private func getPlanets() {
        networkService.makeRequest(
            url: APIConstants.BASEURL,
            httpMethod: .get)
        .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            case .finished:
                break
            }
        } receiveValue: { [weak self] (planet: PlanetResponse) in
            print("I got the planets ", planet.results)
            self?.planets = planet.results
        }.store(in: &cancellables)
    }

}
