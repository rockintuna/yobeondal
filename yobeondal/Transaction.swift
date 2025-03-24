//
//  Untitled.swift
//  yobeondal
//
//  Created by 이정인 on 3/11/25.
//

import Foundation

struct Transaction: Identifiable, Codable {
    init(id: Int, title: String, amount: Int, userName: String) {
        self.id = id
        self.title = title
        self.amount = amount
        self.userName = userName
    }
    
    let id: Int
    let title: String
    let amount: Int
    let userName: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case amount = "amount"
        case userName = "userName"
    }
    
}
