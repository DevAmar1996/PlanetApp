//
//  NetworkMonitorTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing
import Combine

class NetworkMonitorTests {

    var networkMonitor: MockNetworkMonitor = MockNetworkMonitor()
    var cancellables: Set<AnyCancellable> = []

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
