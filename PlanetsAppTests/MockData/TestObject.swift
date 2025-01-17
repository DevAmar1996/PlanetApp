//
//  TestObject.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
struct TestObject: Codable, Equatable {
    let id: Int
    let name: String
}

//prepare the struct that contain invalid property as Any
struct InvalidObject: Encodable {
    let value: Int
    let invalidReference: Any // `Any` is not encodable

    func encode(to encoder: any Encoder) throws {
        let testObject = TestObject(id: 1, name: "Planet Tatooine")
              let key = "testKey"
    }
}
