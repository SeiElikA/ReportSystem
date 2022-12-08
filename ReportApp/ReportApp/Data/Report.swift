//
//  Report.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import Foundation

struct ReportContent: Decodable {
    var id: Int
    var dateTime: String
    var reportDetail: [ReportDetail]
}

struct ReportDetail: Decodable {
    var id: Int
    var content: String
    var imgPath: String
}
