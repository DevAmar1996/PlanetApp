//
//  NetworkServiceTests.swift
//  PlanetsAppTests
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine
import Foundation

final class NetworkServiceTests {
    var mockService: MockNetworkService!
    var cancellables: Set<AnyCancellable> = []

    init() {
        self.mockService = MockNetworkService()
        self.cancellables = []
    }

    deinit {
        self.mockService = nil
        self.cancellables = []
    }

    //test successfull response
    @Test func testNetworkService_Success() async throws {
        //Mock response data
        guard let jsonData = try? Bundle.main.loadJSONData(from: "Planets") else {
            #expect(Bool(false), "failed to load dat from json")
            return
        }
        mockService.data = jsonData
        mockService.makeRequest(url: "https://mockapi.dev/planets", httpMethod: .get)
            .sink { completion in
                //if error arise then test fail
                if case .failure(let error) = completion {
                    #expect(Bool(false) ,"Expacted success but get error: \(error)")
                }
            } receiveValue: { (response: PlanetResponse) in
                //do some test for return data
                #expect(response.results.count == 2)
                #expect(response.results[0].name == "Tatooine")
            }.store(in: &cancellables)
    }

    //test successfull response
    @Test func testNetworkService_Failure() async throws {
        mockService.shouldReturnError = true
        mockService.makeRequest(url: "https://mockapi.dev/planets", httpMethod: .get)
            .sink { completion in
                //if error arise then test fail
                if case .failure(let error) = completion {
                    #expect(true, "get an error \(error)")
                }
            } receiveValue: { (response: PlanetResponse) in
                //do some test for return data
                #expect(Bool(false), "Expect to get error but got success")
            }.store(in: &cancellables)
    }

    //test successfull response
    @Test func testEmptyURl() async throws {
        //Mock response data
        guard let jsonData = try? Bundle.main.loadJSONData(from: "Planets") else {
            #expect(Bool(false), "failed to load dat from json")
            return
        }
        mockService.data = jsonData
        mockService.makeRequest(url: "", httpMethod: .get)
            .sink { completion in
                //if error arise then test fail
                if case .failure(let error) = completion {
                    #expect(true, "invlaid url \(error)")
                }
            } receiveValue: { (response: PlanetResponse) in
                //do some test for return data
                #expect(Bool(false), "Expect to get error but got success")
            }.store(in: &cancellables)
    }
}
