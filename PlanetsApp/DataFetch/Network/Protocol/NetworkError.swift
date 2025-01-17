//
//  NetworkError.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//
import Foundation

//Custom errors for the network layer
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int, message: String)
    case invalidParameter(params: [String: Any])

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidParameter(let params):
            return "Invalid parameter(s): \(params.keys.joined(separator: ", "))"
        case .requestFailed(let statusCode, let message):
            return "The request failed with status code \(statusCode). \(message)"
        }
    }
}
