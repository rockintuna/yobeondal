//
//  Untitled.swift
//  yobeondal
//
//  Created by 이정인 on 3/11/25.
//

import Foundation
import SwiftUI

class TransactionViewModel: ObservableObject {
    
    @Published var response: [Transaction] = []
    var httpClient = HTTPClient()
    
    func getTransactions(_ year: Int,_ month: Int) {
        httpClient.getTransactions(year, month) { result in
            DispatchQueue.main.async { // ✅ 모든 결과 처리를 메인 스레드에서 실행
                switch result {
                case .success(let results):
                    print("✅ HTTP Request SUCCESS")
                    self.response = results
                    
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    self.response = [] // 🚨 실패 시 UI 업데이트가 필요하다면 이렇게 할 수도 있음
                }
            }
        }
    }
    
    var transactionsForSJ: [Transaction] {
        self.response.filter{$0.userName == "수진"}
    }
    var transactionsForJI: [Transaction] {
        self.response.filter{$0.userName == "정인"}
    }
}
