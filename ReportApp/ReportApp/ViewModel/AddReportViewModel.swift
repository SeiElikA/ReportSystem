//
//  AddReportViewModel.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/9.
//

import Foundation
import SwiftUI

class AddReportViewModel: ObservableObject {
    @Published var todayWorkItemList:[String] = []
    @Published var input: String = ""
    @Published var isError = false
    @Published var errorMsg = ""
    @Published var isSuccessful = false
    @Published var successfulMsg = ""
    @Published var isLoading = false
    @Published var isBack = false
    
    public func addWorkItemEvent() {
        if(input.replacingOccurrences(of: " ", with: "").isEmpty) {
            errorMsg = "Work item can't empty"
            isError = true
            return
        }
        
        if(todayWorkItemList.contains(input)) {
            errorMsg = "This item is exist"
            isError = true
            return
        }
        
        withAnimation {
            todayWorkItemList.append(input)
            input = ""
        }
    }
    
    public func sendReportEvent() {
        if(todayWorkItemList.isEmpty) {
            errorMsg = "Please add a work item at least"
            isError = true
            return
        }
        
        withAnimation {
            isLoading = true
        }
        let accountId = UserDefaults.standard.integer(forKey: "id")
        let report = SendReport(accountId: accountId, data: todayWorkItemList.map({Report(content: $0)}))
        let jsonBody = try? JSONEncoder().encode(report)
        
        var request = URLRequest(url: URL(string: Global.baseUrl + "sendReport")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonBody
        URLSession.shared.dataTask(with: request, completionHandler: { data ,response , error in
            guard let data = data else {
                DispatchQueue.main.async {
                    withAnimation {
                        self.isLoading = false
                    }
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if(response.statusCode == 200) {
                    let result = try? JSONDecoder().decode(Response.self, from: data)
                    if result != nil {
                        DispatchQueue.main.async {
                            self.successfulMsg = "Report Successful"
                            self.isSuccessful = true
                            withAnimation {
                                self.isLoading = false
                                self.isBack = true
                            }
                        }
                    }
                } else {
                    let result = try? JSONDecoder().decode(ResponseError.self, from: data)
                    if let result = result {
                        DispatchQueue.main.async {
                            self.errorMsg = result.error
                            self.isError = true
                            self.isLoading = false
                        }
                    }
                }
            }
        }).resume()
    }
    
    public func removeWorkItem(indexSet: IndexSet) {
        indexSet.forEach({
            todayWorkItemList.remove(at: $0)
        })
    }
}
