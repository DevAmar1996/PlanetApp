//
//  URLSessionNetworkServiceTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine

final class URLSessionNetworkServiceTests {

    var networkService: URLSessionNetworkService!
    var cancellables: Set<AnyCancellable>!

    init() {
        self.networkService = URLSessionNetworkService()
        self.cancellables = []
    }

    deinit {
        self.networkService = nil
        self.cancellables = []
    }

    @Test("success test when fetch data from correct url")
    func testMakeRequestSuccess() async throws {
        //test rquest Plenets api using url session
        networkService.makeRequest(url: APIConstants.BASE_URL, httpMethod: .get).sink { completion in
            switch completion {
            case .failure(let error):
                //should not fail
                #expect(Bool(false), "Not expect to get an errror \(error)")
            case .finished:
                ()
            }
        } receiveValue: { (data: PlanetResponse) in
            #expect(Bool(true), "Fetch data successfully \(data)")
        }.store(in: &cancellables)
    }

    @Test("failed test when fetch data from empty url")
    func testMakeRequestFail_EmptyPath() async throws {
        //test rquest Plenets api using url session
        networkService.makeRequest(url: "", httpMethod: .get).sink { completion in
            switch completion {
            case .failure(let error):
                //should not fail
                #expect(Bool(true), "expect to get an errror \(error)")
            case .finished:
                ()
            }
        } receiveValue: { (data: PlanetResponse) in
            #expect(Bool(false), "not expext to fetch data successfully \(data)")
        }.store(in: &cancellables)
    }

    @Test("failed test when fetch data from wrong url")
    func testMakeRequestFail_WrongPath() async throws {

        //test rquest Plenets api using url session
        networkService.makeRequest(url: "https://translate.google.com/?sl=en&tl=ar&op=translate", httpMethod: .get).sink { completion in
            switch completion {
            case .failure(let error):
                //should not fail
                #expect(Bool(true), "expect to get an errror \(error)")
            case .finished:
                ()
            }
        } receiveValue: { (data: PlanetResponse) in
            #expect(Bool(false), "not expext to fetch data successfully \(data)")
        }.store(in: &cancellables)
    }

}
