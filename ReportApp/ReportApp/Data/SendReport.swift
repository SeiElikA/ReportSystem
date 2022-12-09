//
//  SendReport.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/9.
//

import Foundation
import SwiftUI

struct SendReport: Encodable {
    var accountId: Int
    var data: [Report]
}

struct Report: Encodable {
    var content: String
}
