//
//  Report.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import Foundation

struct ReportContent: Decodable, Identifiable, Equatable {
    var id: Int
    var dateTime: String
    var reportDetail: [ReportDetail]
    var yearMonth:String?
    var day: String?
    var dateValue: Date?
}

struct ReportDetail: Decodable, Equatable {
    var id: Int
    var content: String
    var imgPath: String
}
