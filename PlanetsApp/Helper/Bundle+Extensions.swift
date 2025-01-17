//
//  AnyObject+Extension.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation

import Foundation

extension Bundle {
    /// Load JSON data from a file in the specified bundle.
    /// - Parameter fileName: The name of the JSON file (without the extension).
    /// - Returns: The loaded data from the file.
    /// - Throws: An error if the file is not found or cannot be read.
    func loadJSONData(from fileName: String) throws -> Data {
        guard let url = self.url(forResource: fileName, withExtension: "json") else {
            throw NSError(
                domain: "JSONLoading",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "File \(fileName).json not found in bundle."]
            )
        }
        return try Data(contentsOf: url)
    }
}
