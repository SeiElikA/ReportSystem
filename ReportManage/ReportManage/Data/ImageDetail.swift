//
//  ImageDetail.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/10.
//

import Foundation

struct ImageDetail: Decodable, Equatable,Identifiable {
    var id: Int
    var imgPath: String
}
