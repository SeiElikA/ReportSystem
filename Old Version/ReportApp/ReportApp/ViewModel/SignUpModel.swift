//
//  SignUpModel.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import SwiftUI

class SignUpModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var confirmPassword = ""
    @Published var isError = false
    @Published var errorMsg = ""
    @Published var isLoading = false
    @Published var isSuccessful = false
    @Published var successfulMsg = ""
    
    public func signUpEvent() {
        if(!email.contains("@") || !email.contains(".")) {
            errorMsg = "Email format not correct"
            isError = true
            return
        }
        
        if("\(password)".count < 8) {
            errorMsg = "Your password is too easy"
            isError = true
            return
        }
        
        if("\(confirmPassword)" != "\(password)") {
            errorMsg = "Confirm password not match"
            isError = true
            return
        }
        
        if(name.isEmpty) {
            errorMsg = "Name can't empty"
            isError = true
            return
        }
        
        isLoading = true
        
        let url = URL(string: Global.baseUrl + "signUp")!
        let body = Register(name: name, password: "\(password)", email: email)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request, completionHandler: { data ,response , error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if(response.statusCode == 200) {
                    let result = try? JSONDecoder().decode(Response.self, from: data)
                    if result != nil {
                        DispatchQueue.main.async {
                            self.successfulMsg = "Register Successful"
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
        
        isLoading = false
    }
}
