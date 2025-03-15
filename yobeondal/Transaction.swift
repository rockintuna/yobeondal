//
//  Untitled.swift
//  yobeondal
//
//  Created by 이정인 on 3/11/25.
//

import Foundation

struct Transaction: Identifiable, Codable {
    init(title: String, amount: Int, userName: String) {
        self.title = title
        self.amount = amount
        self.userName = userName
    }
    
    let id: UUID = UUID()
    let title: String
    let amount: Int
    let userName: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case amount = "amount"
        case userName = "userName"
    }
    
}
