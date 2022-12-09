//
//  LoginView.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var model = LoginViewModel()
    
    var body: some View {
        ZStack {
            ZStack {
                List {
                    Group {
                        TextField(text: $model.email, label: {
                            Text("Email")
                        })
                        .autocapitalization(.none)
                        
                        SecureField(text: $model.password, label: {
                            Text("Password")
                        })
                        .autocapitalization(.none)
                    }
                    
                    Section {
                        Button(action: model.loginEvent) {
                            Text("Login")
                        }
                    }

                }
                .listStyle(.insetGrouped)
                
                VStack {
                    Spacer()
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                NavigationLink("", destination: ContentView(), isActive: $model.isLogin)
                
         
            }
            
            if model.isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(Text("Login"))
        .alert("Successful", isPresented: $model.isSuccessful, actions: {
            Button("Confirm", action: {
                model.isLogin = true
            })
        }, message: {
            Text(model.successfulMsg)
        })
        .alert("Error", isPresented: $model.isError, actions: {}, message: {
            Text(model.errorMsg)
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content: {
            LoginView()
        })
    }
}
