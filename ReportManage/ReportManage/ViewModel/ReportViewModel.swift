//
//  ReportViewModel.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/11.
//

import Foundation
import SwiftUI

class ReportViewModel: ObservableObject {
    @Published var reportList: [Report] = []
    @Published var filterList: [Report] = []
    @Published var allDateList: [String] = ["All"]
    @Published var allAccountList: [String] = ["All"]
    @Published var selectionId: Int?
    @Published var isError = false
    @Published var errorMsg = ""
    @Published var isLoading = false
    @Published var isSuccessful = false
    @Published var successfulMsg = ""
    @Published var selectAccount = "All"
    @Published var selectDate = "All"
    
    public func fetchReportList() {
        isLoading = true
        allDateList = []
        allAccountList = []
        let request = URLRequest(url: URL(string: Global.baseUrl + "getAllReport")!)
        URLSession.shared.dataTask(with: request, completionHandler: { data ,response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMsg = error.localizedDescription
                    self.isError = true
                    self.isLoading = false
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    
                    if let reportList = try? JSONDecoder().decode([Report].self, from: data) {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.reportList = reportList
                                self.filterList = reportList
                                self.selectDate = "All"
                                self.selectAccount = "All"
                                reportList.map({$0.account.name}).forEach({self.allAccountList.append($0)})
                                self.allAccountList = Array(Set(self.allAccountList))
                                reportList.map({$0.dateTime}).forEach({self.allDateList.append($0)})
                                self.allDateList = Array(Set(self.allDateList))
                                self.allDateList.insert("All", at: 0)
                                self.allAccountList.insert("All", at: 0)
                                self.isLoading = false
                            }
                        }
                    }
                }
            }
        }).resume()
    }
    
    public func filterChangeEvent() {
        if selectAccount == "All" && selectDate == "All" {
            filterList = reportList
        } else if selectAccount == "All" {
            filterList = reportList.filter({$0.dateTime == selectDate })
        } else if selectDate == "All" {
            filterList = reportList.filter({$0.account.name == selectAccount })
        }
    }
}
