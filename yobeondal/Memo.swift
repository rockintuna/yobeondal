//
//  Untitled.swift
//  yobeondal
//
//  Created by 이정인 on 3/11/25.
//

import Foundation

struct Memo: Identifiable, Codable {
    init(id: Int, content: String, userName: String) {
        self.id = id
        self.content = content
        self.userName = userName
    }
    
    let id: Int
    let content: String
    let userName: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case content = "content"
        case userName = "userName"
    }
    
}
