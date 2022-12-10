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
            
            if !reportContent.imageDetail.isEmpty {
                Section("Images") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(reportContent.imageDetail) { imgDetail in
                                AsyncImage(url: URL(string: Global.baseUrl + imgDetail.imgPath)!, content: { img in
                                    img
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(8)
                                }, placeholder: {
                                    Rectangle()
                                        .fill(Color("Gray"))
                                        .frame(width: 200, height: 200)
                                        .overlay(ProgressView())
                                        .cornerRadius(8)
                                })
                            }
                        }
                    }
                }
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
            ReportDetailView(reportContent: MainViewModel.reportContent.first!)
        }
    }
}
