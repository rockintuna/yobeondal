//
//  Untitled.swift
//  yobeondal
//
//  Created by 이정인 on 3/11/25.
//

import Foundation
import SwiftUI

class MemoViewModel: ObservableObject {
    
    @Published var response: [Memo] = []
    @Published var success: Bool? = nil
    var httpClient = HTTPClient()
    
    
    func getMemos(_ year: Int,_ month: Int) {
        httpClient.getMemos(year, month) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    print("HTTP GET MEMO SUCCESS")
                    self.response = results
                    
                case .failure(let error):
                    print("HTTP Error: \(error.localizedDescription)")
                    self.response = []
                }
            }
        }
    }
    
    func createMemo(_ year: Int,_ month: Int,_ content: String,_ userId: Int) {
        httpClient.createMemo(year, month, content, userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    print("HTTP Memo create SUCCESS")
                    self.success = true
                    self.getMemos(year, month)
                    
                case .failure(let error):
                    print("HTTP Error: \(error.localizedDescription)")
                    self.success = false
                }
            }
        }
    }
    
    func deleteMemo(_ id: Int,_ year: Int,_ month: Int) {
        httpClient.deleteMemo(id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    print("HTTP Memo delete SUCCESS")
                    self.success = true
                    self.getMemos(year, month)
                    
                case .failure(let error):
                    print("HTTP Error: \(error.localizedDescription)")
                    self.success = false
                }
            }
        }
    }
}
