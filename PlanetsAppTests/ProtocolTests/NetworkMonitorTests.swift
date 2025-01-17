//
//  NetworkMonitorTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine

final class NetworkMonitorTests {

    var networkMonitor: MockNetworkMonitor!
    var cancellables: Set<AnyCancellable> = []

    init() {
        self.networkMonitor = MockNetworkMonitor()
        self.cancellables = []
    }

    deinit {
        self.networkMonitor = nil
        self.cancellables = []
    }

    @Test func testNetworkConnected() async throws {
        //check network state connected
        // Simulate the network change
        networkMonitor.simulateNetworkChange(to: true)
        networkMonitor.isConnectedPublisher.sink { isConnected in
            #expect(isConnected)
        }.store(in: &cancellables)
    }

    @Test func testNetworkDisConnect() async throws {
        // Simulate the network change
        networkMonitor.simulateNetworkChange(to: false)
        //check network state disconnect
        networkMonitor.isConnectedPublisher.sink { isConnected in
            #expect(!isConnected)
        }.store(in: &cancellables)
    }

}
