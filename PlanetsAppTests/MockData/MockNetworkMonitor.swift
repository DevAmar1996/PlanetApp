//
//  MockNetworkMonitor.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Combine

class MockNetworkMonitor: NetworkMonitor {
    //simaulate network status
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(false)

    override var isConnected: Bool {
        isConnectedSubject.value
    }

    override var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }

    //simulate network state change
    func simulateNetworkChange(to isConnected: Bool) {
          isConnectedSubject.send(isConnected)
    }
}
