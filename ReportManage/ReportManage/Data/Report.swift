//
//  Report.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/11.
//

import Foundation

struct Report: Identifiable, Decodable {
    var id: Int
    var dateTime: String
    var account: Account
    var imageDetail: [ImageDetail]
    var reportDetail: [ReportDetail]
}
