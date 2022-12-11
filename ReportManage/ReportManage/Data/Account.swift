//
//  Account.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/11.
//

import Foundation

struct Account: Identifiable, Decodable {
    var id: Int
    var name: String
    var email: String
    var password: String
}
