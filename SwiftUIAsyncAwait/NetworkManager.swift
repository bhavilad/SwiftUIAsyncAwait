//
//  NetworkManager.swift
//  SwiftUIAsyncAwait
//
//  Created by Bhavi Mistry on 14/08/2024.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/xxxx"

        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
         
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw APIError.invalidData
        }
    }
    
    // generic func for fetching
    func fetchData<T: Decodable>(for: T.Type, from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
}
