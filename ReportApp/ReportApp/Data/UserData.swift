//
//  UserData.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import Foundation
struct UserData: Decodable {
    public var id: Int
    public var name: String
    public var email: String
    public var password: String
}
