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
    var imageDetail: [ImageDetail]
    var yearMonth:String?
    var day: String?
    var dateValue: Date?
}

struct ReportDetail: Decodable, Equatable,Identifiable {
    var id: Int
    var content: String
}

struct ImageDetail: Decodable, Equatable,Identifiable {
    var id: Int
    var imgPath: String
}

