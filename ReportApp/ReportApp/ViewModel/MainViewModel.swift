//
//  MainViewModel.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    private static var reportDetail:[ReportDetail] = [
        ReportDetail(id: 1, content: "完成relay閃燈控制", imgPath: ""),
        ReportDetail(id: 2, content: "找到物理喇叭撥放法", imgPath: ""),
        ReportDetail(id: 3, content: "音量控制", imgPath: ""),
        ReportDetail(id: 4, content: "正常播放音檔", imgPath: ""),
    ]
    
    @Published var reportList: [ReportContent] = [
        ReportContent(id: 1, dateTime: "2022-12-08", reportDetail: reportDetail),
        ReportContent(id: 2, dateTime: "2022-02-10", reportDetail: reportDetail),
        ReportContent(id: 3, dateTime: "2022-02-07", reportDetail: reportDetail)
    ]
    @Published var isLogout = false
    @Published var isLoading = false
    @Published var isError = false
    @Published var errorMsg = ""
    
    public func logoutEvent() {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "isLogin")
        
        withAnimation {
            isLogout = true
        }
    }
    
    public func fetchReportRecord() {
        withAnimation {
            isLoading = true
        }
        
        var request = URLRequest(url: URL(string: Global.baseUrl + "getReport")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = [
            "accountId": UserDefaults.standard.integer(forKey: "id")
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request, completionHandler: { data ,response , error in
            guard let data = data else {
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if(response.statusCode == 200) {
                    let result = try? JSONDecoder().decode([ReportContent].self, from: data)
                    if let result = result {
                        DispatchQueue.main.async {
                            // save user data
                            withAnimation {
                                self.reportList = result
                            }
                        }
                    }
                } else {
                    let result = try? JSONDecoder().decode(ResponseError.self, from: data)
                    if let result = result {
                        DispatchQueue.main.async {
                            self.errorMsg = result.error
                            self.isError = true
                        }
                    }
                }
            }
        }).resume()
    }
}
