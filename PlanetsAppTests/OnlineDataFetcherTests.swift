//
//  OnlineDataFetcherTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine
import Foundation

final class OnlineDataFetcherTests {
    var mockNetworkService: MockNetworkService!
    var onlineDataFetcher: OnlineDataFetcher<TestObject>!
    var cancellables: Set<AnyCancellable> = []

    init() {
        mockNetworkService = MockNetworkService()
        self.onlineDataFetcher = OnlineDataFetcher(networkService:  mockNetworkService)
        cancellables = []
    }

    deinit {
        //remove all referance after each test
        cancellables = []
        mockNetworkService = nil
        onlineDataFetcher = nil
    }

    @Test("online fetch data from correct source")
    func testFetchData_Success() {
        //Mock response data
        let testObject = TestObject(id: 1, name: "Planet Tatooine")
        let jsonData = try! JSONEncoder().encode(testObject)
        mockNetworkService.data = jsonData
        mockNetworkService.shouldReturnError = false
        onlineDataFetcher.fetchData(path: APIConstants.BASEURL)
            .sink { completion in
                if case .failure(let error) = completion {
                    #expect(Bool(false), "Unexpected error: \(error)")
                }
            } receiveValue: { response in
                #expect(response == testObject, "The fetched data should match the mock data")
            }.store(in: &cancellables)
    }

    @Test("online fetch data from wrong source")
     func testFetchData_Failure() {
        mockNetworkService.shouldReturnError = true
        onlineDataFetcher.fetchData(path: "")
            .sink { completion in
                if case .failure(let error) = completion {
                    #expect(error is URLError, "Expected URLError got \(error)")
                }
            } receiveValue: { response in
                #expect(Bool(false), "Expected failure but got success.")
            }.store(in: &cancellables)
    }
}
