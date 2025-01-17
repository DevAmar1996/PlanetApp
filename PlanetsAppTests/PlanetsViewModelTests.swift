//
//  PlanetsViewModelTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine
import Foundation

final class PlanetsViewModelTests {
    var viewModel: PlanetsViewModel!
    var mockDataFetcher: MockDataFetcher!
    var cancellables: Set<AnyCancellable>!

    init() {
        self.mockDataFetcher = MockDataFetcher()
        self.viewModel = PlanetsViewModel(dataFetcher: mockDataFetcher)
        self.cancellables = []
    }

    deinit {
        viewModel = nil
        mockDataFetcher = nil
        cancellables = nil
    }

    @Test func testGetPlanetsSuccess() {
        do {
            // Arrange
            let jsonData = try Bundle.main.loadJSONData(from: "Planets")
            let expectedPlanets = try JSONDecoder().decode(PlanetResponse.self, from: jsonData)
            mockDataFetcher.mockData = expectedPlanets.results
            mockDataFetcher.isOffline = false

            viewModel.loadViewContent()

            viewModel.$planets
                .sink { planets in
                    // Assert
                    #expect(planets == expectedPlanets.results,
                            "Planets should match the mock data.")
                }.store(in: &cancellables)

        } catch {
            #expect(Bool(false), "Unexpecte error: \(error)")
        }
    }

    @Test func testGetPlanetsOnlineFailure() {
        mockDataFetcher.isOffline = false
        viewModel.loadViewContent()
        viewModel.$errorMessage
            .sink { errorMessage in
                #expect(errorMessage != nil, "Error message should not be nil.")
                #expect(errorMessage == NetworkError.requestFailed(statusCode: 500, message: "Data unavailable").localizedDescription, "Error should be network error")
            }.store(in: &cancellables)
    }

    @Test func testGetPlanetsOfflineFailure() {
        mockDataFetcher.isOffline = true
        viewModel.loadViewContent()
        viewModel.$errorMessage
            .sink { errorMessage in
                #expect(errorMessage != nil, "Error message should not be nil.")
                #expect(errorMessage == OfflineError.noDataAvailable.localizedDescription , "Error should be network error")
            }.store(in: &cancellables)

    }
}
