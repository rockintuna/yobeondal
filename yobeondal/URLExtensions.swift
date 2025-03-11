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
}
