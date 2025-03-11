//
//  Untitled.swift
//  yobeondal
//
//  Created by 이정인 on 3/11/25.
//

import Foundation

// 1
enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}
// 2
class HTTPClient {
    // 3
    func getTransactions(_ year: Int,_ month: Int, completion: @escaping (Result<[Transaction], NetworkError>) -> Void) {
        // 4
        guard let url = URL.getTransactionsUrl(year, month) else {
            return completion(.failure(.badURL))
        }
        // 5
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 6
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            // 7
            guard let transactions = try? JSONDecoder().decode([Transaction].self, from: data) else {
                return completion(.failure(.decodingError))
            }
            // 8
            completion(.success(transactions))
            
        }.resume()
        
    }
}
