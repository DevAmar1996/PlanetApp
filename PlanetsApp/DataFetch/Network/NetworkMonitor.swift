//
//  NetworkMonitor.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Network

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
}

class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private(set) var isConnected = false

    init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
