//
//  ReportDetail.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/11.
//

import Foundation

struct ReportDetail: Decodable, Equatable,Identifiable {
    var id: Int
    var content: String
}
