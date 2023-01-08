//
//  LoginViewModel.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var isLogin = false
    @Published var isError = false
    @Published var errorMsg = ""
    @Published var isSuccessful = false
    @Published var successfulMsg = ""

    public func loginEvent() {
        let password = "\(password)"
        
        var request = URLRequest(url: URL(string: Global.baseUrl + "login")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(Login(email: email, password: password))
        URLSession.shared.dataTask(with: request, completionHandler: { data ,response , error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if(response.statusCode == 200) {
                    let result = try? JSONDecoder().decode(UserData.self, from: data)
                    if let result = result {
                        DispatchQueue.main.async {
                            // save user data
                            UserDefaults.standard.setValue(result.id, forKey: "id")
                            UserDefaults.standard.setValue(result.email, forKey: "email")
                            UserDefaults.standard.setValue(result.password, forKey: "password")
                            UserDefaults.standard.setValue(result.name, forKey: "name")
                            UserDefaults.standard.setValue(true, forKey: "isLogin")
                            
                            self.successfulMsg = "Login Successful"
                            self.isSuccessful = true
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
