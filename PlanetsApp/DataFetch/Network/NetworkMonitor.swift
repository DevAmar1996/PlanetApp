//
//  NetworkMonitor.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Network
import Combine

protocol NetworkMonitorProtocol {
     var isConnected: Bool { get }
     var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
}

class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    @Published private(set) var isConnected = false

    //get updated when ever is connected updated
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        $isConnected.eraseToAnyPublisher()
    }

    init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
