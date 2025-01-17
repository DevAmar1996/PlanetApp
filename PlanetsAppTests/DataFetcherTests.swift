//
//  DataFetcherTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine
import Foundation

final class DataFetcherTests {
    var dataFetcher: DataFetcherRepository!
    var mockOfflineFetcher: MockDataFetcher!
    var mockOnlineFetcher: MockDataFetcher!
    var mockLocalStorage: MockLocalStorage!
    var mockNetworkMonitor: MockNetworkMonitor = MockNetworkMonitor()
    var mockNetworkService: MockNetworkService = MockNetworkService()
    var cancellables: Set<AnyCancellable> = []

    init() {
        mockLocalStorage = MockLocalStorage()
        mockOnlineFetcher = MockDataFetcher()
        mockOfflineFetcher = MockDataFetcher()
        dataFetcher = DataFetcherRepository(offlineFetcher: mockOfflineFetcher, onlineFetcher: mockOnlineFetcher, localStorage: mockLocalStorage, networkMonitor: mockNetworkMonitor)
        cancellables = []
    }

    deinit {
        mockLocalStorage = nil
        mockOnlineFetcher = nil
        mockOfflineFetcher = nil
        dataFetcher = nil
        cancellables = []
    }

    @Test("ensure data taken from online fetch while internet is available")
    func testValidOnlineFetch() {
        do {
            let mockPlanets = try loadMockData(from: "Planets", as: PlanetResponse.self)

            mockOnlineFetcher.mockData = mockPlanets

            mockNetworkMonitor.simulateNetworkChange(to: true)

            dataFetcher.fetchData(path: APIConstants.BASE_URL, PlanetResponse.self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        #expect(Bool(false), "Unexpected error: \(error)")
                    }
                } receiveValue: { planet in
                    #expect(planet.results == mockPlanets.results, "The fetched data should match the mocked data")
                }.store(in: &cancellables)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test("test invlalid status in online fetch while internet is available")
    func testInValidOnlineFetch() {
        mockOnlineFetcher.isOffline = false

        mockNetworkMonitor.simulateNetworkChange(to: true)

        dataFetcher.fetchData(path: "", PlanetResponse.self)
            .sink { completion in
                if case .failure(let error) = completion {
                    #expect(error is NetworkError, "Unexpected error: \(error)")
                }
            } receiveValue: { planet in
                #expect(Bool(false), "Expect error but get planet: \(planet)")
            }.store(in: &cancellables)
    }

    @Test("ensure data taken from offline repo while internet is unavailable")
    func testFetchDataOffline_Fallback() {
        do {
            // Mock offline data
            let mockOfflinePlanets = try loadMockData(from: "OfflinePlanets", as: PlanetResponse.self)
            mockOfflineFetcher.mockData = mockOfflinePlanets.results

            // Simulate online network status
            mockNetworkMonitor.simulateNetworkChange(to: false)

            dataFetcher.fetchData(path: APIConstants.BASE_URL, PlanetResponse.self)
                .sink { completion in
                    if case .failure(let error) = completion {
                        #expect(Bool(false), "Unexpected error: \(error)")
                    }
                } receiveValue: { planet in
                    #expect(planet.results == mockOfflinePlanets.results, "The fetched data should match the offline mocked data")
                }.store(in: &cancellables)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test("test invlalid status in offline fetch while internet is unavailable")
    func testInValidOfflineFetch() {
        mockOnlineFetcher.isOffline = true

        mockNetworkMonitor.simulateNetworkChange(to: true)

        dataFetcher.fetchData(path: "", PlanetResponse.self)
            .sink { completion in
                if case .failure(let error) = completion {
                    #expect(error is OfflineError, "Unexpected error: \(error)")
                }
            } receiveValue: { planet in
                #expect(Bool(false), "Expect error but get planet: \(planet)")
            }.store(in: &cancellables)
    }

    func loadMockData<T: Decodable>(from fileName: String, as type: T.Type) throws -> T {
        do {
            let data = try Bundle.main.loadJSONData(from: fileName)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            #expect(Bool(false), "Failed to load or decode \(fileName).json: \(error)")
            throw  error
        }
    }
}
