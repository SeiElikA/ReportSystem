//
//  ReportDetailView.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/9.
//

import SwiftUI

struct ReportDetailView: View {
    @State var reportContent: ReportContent
    
    var body: some View {
        List {
            Section("Work Items") {
                ForEach(reportContent.reportDetail, content: { report in
                    Text("\((reportContent.reportDetail.firstIndex(of: report) ?? 0) + 1). \(report.content)")
                })
            }
            
            Section("Date") {
                Text(reportContent.dateTime.replacingOccurrences(of: "-", with: "."))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Text("Report Detail"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReportDetailView(reportContent: (ReportContent(id: 1, dateTime: "2022-02-02", reportDetail: [
                ReportDetail(id: 1, content: "test", imgPath: ""),
                ReportDetail(id: 2, content: "test", imgPath: ""),
                ReportDetail(id: 3, content: "test", imgPath: ""),
                ReportDetail(id: 4, content: "test", imgPath: "")
            ])))
        }
    }
}
