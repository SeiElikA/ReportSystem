//
//  AllImageViewModel.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/10.
//

import Foundation
import SwiftUI

class AllImageViewModel: ObservableObject {
    @Published var imgList: [ImageDetail] = []
    @Published var isError = false
    @Published var errorMsg = ""
    @Published var isLoading = false
    @Published var isSuccessful = false
    @Published var successfulMsg = ""
    
    public func fetchImgList() {
        isLoading = true
        let request = URLRequest(url: URL(string: Global.baseUrl + "getAllImage")!)
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
                    
                    if let imageList = try? JSONDecoder().decode([ImageDetail].self, from: data) {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.imgList = imageList
                                self.isLoading = false
                            }
                        }
                    }
                }
            }
        }).resume()
    }
}
