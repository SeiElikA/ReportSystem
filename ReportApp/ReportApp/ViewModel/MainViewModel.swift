//
//  MainViewModel.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    public static var reportContent: [ReportContent] = [
        ReportContent(id: 1, dateTime: "2022-02-02", reportDetail: [
            ReportDetail(id: 1, content: "test"),
            ReportDetail(id: 2, content: "test"),
            ReportDetail(id: 3, content: "test"),
            ReportDetail(id: 4, content: "test"),
            ReportDetail(id: 5, content: "test")
        ], imageDetail: [
            ImageDetail(id: 1, imgPath: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png"),
            ImageDetail(id: 2, imgPath: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png"),
            ImageDetail(id: 3, imgPath: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png"),
        ]),
        ReportContent(id: 2, dateTime: "2022-02-02", reportDetail: [
            ReportDetail(id: 1, content: "test"),
            ReportDetail(id: 2, content: "test"),
            ReportDetail(id: 3, content: "test"),
            ReportDetail(id: 4, content: "test")
        ],imageDetail: [])
    ]
    
    @Published var todayString = ""
    @Published var reportList: [ReportContent] = []
    @Published var isLogout = false
    @Published var isLoading = false
    @Published var isError = false
    @Published var errorMsg = ""
    @Published var isLogoutAlert = false
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        todayString = dateFormatter.string(from: Date.now)
    }
    
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
                DispatchQueue.main.async {
                    withAnimation {
                        self.isLoading = false
                    }
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if(response.statusCode == 200) {
                    let result = try? JSONDecoder().decode([ReportContent].self, from: data)
                    if let result = result {
                        DispatchQueue.main.async {
                            // save user data
                            withAnimation {
                                self.reportList = result.map({ content in
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    
                                    let date = dateFormatter.date(from: content.dateTime) ?? Date()
                                    let day = Calendar.current.component(.day, from: date)
                                    let year = Calendar.current.component(.year, from: date)
                                    let month = Calendar.current.component(.month, from: date)
                                    
                                    var reportContent = ReportContent(id: content.id, dateTime: content.dateTime, reportDetail: content.reportDetail, imageDetail: content.imageDetail)
                                    reportContent.dateValue = date
                                    reportContent.day = "\(day)"
                                    reportContent.yearMonth = "\(year)-\(month)"
                                    return reportContent
                                })
                                self.isLoading = false
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
}
