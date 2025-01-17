//
//  DataFetcherTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine
import Foundation

class DataFetcherTests {
    var dataFetcher: PlanerDataFetcher!
      var mockOfflineFetcher: MockOfflineDataFetcher<[Planet]>!
      var mockOnlineFetcher: MockOnlineDataFetcher<PlanetResponse>!
    var mockLocalStorage: MockLocalStorage = MockLocalStorage()
    var mockNetworkMonitor: MockNetworkMonitor = MockNetworkMonitor()
    var mockNetworkService: MockNetworkService = MockNetworkService()
    var cancellables: Set<AnyCancellable> = []

    init() {
        mockOnlineFetcher = MockOnlineDataFetcher(networkService: MockNetworkService())
        mockOfflineFetcher = MockOfflineDataFetcher(localStorage: mockLocalStorage)
        self.dataFetcher = PlanerDataFetcher(offlineFetcher: mockOfflineFetcher, onlineFetcher: mockOnlineFetcher, localStorage: mockLocalStorage, networkMonitor: mockNetworkMonitor)
    }
    
    @Test func testFetchDataOnline_Success() async throws {
        do {
            let data = try Bundle.main.loadJSONData(from: "Planets")

            let mockPlanets: PlanetResponse = try JSONDecoder().decode(PlanetResponse.self, from: data)

            mockOnlineFetcher.mockData = mockPlanets

            mockOnlineFetcher.shouldReturnError = false

            mockNetworkMonitor.simulateNetworkChange(to: true)

            dataFetcher.fetchData(path: APIConstants.BASEURL)
                .sink { completion in
                    if case .failure(let error) = completion {
                        #expect(Bool(false), "Unexpected error: \(error)")
                    }
                } receiveValue: { planets in
                    #expect(planets == mockPlanets.results, "The fetched data should match the mocked data")
                }.store(in: &cancellables)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test func testFetchDataOnline_Fail() async throws {
        mockOnlineFetcher.shouldReturnError = true

        mockNetworkMonitor.simulateNetworkChange(to: false)

        dataFetcher.fetchData(path: APIConstants.BASEURL)
            .sink { completion in
                if case .failure(let error) = completion {
                    #expect(Bool(false), "Unexpected error: \(error)")
                }
            } receiveValue: { planets in
                #expect(planets == mockPlanets.results, "The fetched data should match the mocked data")
            }.store(in: &cancellables)
    } catch {
        #expect(Bool(false), "Unexpected error: \(error)")
    }
    }

}
