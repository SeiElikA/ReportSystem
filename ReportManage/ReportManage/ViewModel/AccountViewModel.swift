//
//  AccountViewModwel.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/11.
//

import Foundation
import SwiftUI

class AccountViewModel: ObservableObject {
    @Published var accountList: [Account] = []
    @Published var selectionId: Int?
    @Published var isError = false
    @Published var errorMsg = ""
    @Published var isLoading = false
    @Published var isSuccessful = false
    @Published var successfulMsg = ""
    
    public func fetchAccountList() {
        isLoading = true
        let request = URLRequest(url: URL(string: Global.baseUrl + "getAllAccount")!)
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
                    
                    if let accountList = try? JSONDecoder().decode([Account].self, from: data) {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.accountList = accountList
                                self.isLoading = false
                            }
                        }
                    }
                }
            }
        }).resume()
    }
}
