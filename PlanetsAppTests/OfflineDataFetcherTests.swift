//
//  OfflineDataFetcherTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine

final class OfflineDataFetcherTests {
    var mockLocalStorage: MockLocalStorage!
    var offlineDataFetcher: OfflineDataFetcher!
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        mockLocalStorage  = MockLocalStorage()
        offlineDataFetcher = OfflineDataFetcher(localStorage: mockLocalStorage)
        cancellables = []
    }

    deinit {
        mockLocalStorage = nil
        offlineDataFetcher = nil
        cancellables = []
    }

    @Test("Offline fetch data while key is existing in local storage")
    func testFetchData_Success() {
        //prepare object
        let testObject = TestObject(id: 1, name: "Planet Tatooine")
        let key = "testKey"
        
        do {
            //save it in local storage
            try mockLocalStorage.saveObject(testObject, forKey: key)
            
            //should fetch data successfuly
            offlineDataFetcher.fetchData(path: key, TestObject.self)
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
    
    @Test("Offline fetch data while key is no existing in local storage")
    func testFetchData_Failure() {
        let key = "unexistKey"
        do {
            //key not exist should return error
            offlineDataFetcher.fetchData(path: key, TestObject.self)
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
