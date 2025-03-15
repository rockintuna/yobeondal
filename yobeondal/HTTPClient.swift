//
//  Untitled.swift
//  yobeondal
//
//  Created by 이정인 on 3/11/25.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

class HTTPClient {

    func getTransactions(_ year: Int,_ month: Int, completion: @escaping (Result<[Transaction], NetworkError>) -> Void) {
        guard let url = URL.getTransactionsUrl(year, month) else {
            return completion(.failure(.badURL))
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }

            guard let transactions = try? JSONDecoder().decode([Transaction].self, from: data) else {
                return completion(.failure(.decodingError))
            }

            completion(.success(transactions))
            
        }.resume()
        
    }
    
    func upsertTransactions(_ tid: Int?, _ year: Int,_ month: Int,_ title: String,_ amount: Int,_ userId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let url = URL.postTransactionsUrl() else {
            return completion(.failure(.badURL))
        }
        
        let transactionData: [String: Any] = ["title" : title, "amount" : amount, "userId" : userId, "year" : year, "month" : month]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: transactionData) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
    
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.noData))
            }
            
            completion(.success("OK"))
            
        }.resume()
    }
}
