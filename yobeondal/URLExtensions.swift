//
//  Untitled.swift
//  yobeondal
//
//  Created by 이정인 on 3/11/25.
//

import Foundation

extension URL {
    
    static func getTransactionsUrl(_ year: Int, _ month: Int) -> URL? {
        return URL(string: "http://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/transactions?year=\(year)&month=\(month)")
    }
    
    static func postTransactionsUrl() -> URL? {
        return URL(string: "http://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/transactions")
    }
    
    static func patchTransactionsUrl(_ id: Int) -> URL? {
        return URL(string: "http://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/transactions/\(id)")
    }
    
    static func deleteTransactionsUrl(_ id: Int) -> URL? {
        return URL(string: "http://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/transactions/\(id)")
    }
    
    static func getMemosUrl(_ year: Int, _ month: Int) -> URL? {
        return URL(string: "http://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/memos?year=\(year)&month=\(month)")
    }
    
    static func postMemosUrl() -> URL? {
        return URL(string: "http://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/memos")
    }
    
    static func deleteMemosUrl(_ id: Int) -> URL? {
        return URL(string: "http://\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/api/memos/\(id)")
    }
}
