//
//  NetworkMonitor.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Network
import Combine

/// A protocol defining the behavior of a network monitor.
/// It provides properties to check the current network connection status and observe connection changes.
protocol NetworkMonitor {
    /// Indicates whether the device is currently connected to the network.
    var isConnected: Bool { get }

    /// A combine publisher that publish the updates whenever network connection status changed
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
}

class PlanetNetworkMonitor: NetworkMonitor {
    /// instance to monitor network path changes
    private let monitor = NWPathMonitor()

    /// A background queue to execute network monitoring tasks.
    private let queue = DispatchQueue.global(qos: .background)

    @Published private(set) var isConnected = true

    /// get updated when ever is connected updated
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        $isConnected.eraseToAnyPublisher()
    }

    /// Initializes the `PlanetNetworkMonitor` and starts monitoring the network status.
    /// The monitor observes changes to the network path and updates the `isConnected` property
    init() {
        monitor.pathUpdateHandler = { path in
            /// update the is connected variable based on network status
            self.isConnected = path.status == .satisfied
        }

        // start the network monitor on the background queue
        monitor.start(queue: queue)
    }
}
