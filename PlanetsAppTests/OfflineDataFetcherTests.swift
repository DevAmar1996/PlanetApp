//
//  OfflineDataFetcherTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine

class OfflineDataFetcherTests {
    var mockLocalStorage: MockLocalStorage = MockLocalStorage()
    var offlineDataFetcher: OfflineDataFetcher<TestObject>!
    var cancellables: Set<AnyCancellable> = []

    init() {
        self.offlineDataFetcher = OfflineDataFetcher(localStorage: mockLocalStorage)
    }

    @Test func testFetchData_Success() async throws {
        //prepare object
        let testObject = TestObject(id: 1, name: "Planet Tatooine")
        let key = "testKey"

        do {
            //save it in local storage
            try mockLocalStorage.saveObject(testObject, forKey: key)

            //should fetch data successfuly
            offlineDataFetcher.fetchData(path: key)
                .sink { completion in
                    if case .failure(let error) = completion {
                        #expect(Bool(false), "Unexpected error: \(error)")
                    }
                } receiveValue: { result in
                    #expect(result == testObject, "The fetched data should match the saved data")
                }.store(in: &cancellables)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

   @Test func testFetchData_Failure() {
        let key = "unexistKey"
        do {
            //key not exist should return error
            offlineDataFetcher.fetchData(path: key)
                .sink { completion in
                    if case .failure(let error) = completion {
                        #expect(error as! OfflineError == OfflineError.noDataAvailable, "error should be data not available")
                    }
                } receiveValue: { result in
                    #expect(Bool(false), "Expected failure but got success.")
                }.store(in: &cancellables)
        }
    }


}
