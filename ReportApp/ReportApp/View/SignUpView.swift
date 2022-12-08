//
//  SignUpView.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var model = SignUpModel()
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack {
            ZStack {
                List {
                    Group {
                        TextField(text: $model.email, label: {
                            Text("Email")
                        })
                        
                        SecureField(text: $model.password, label: {
                            Text("Password")
                        })
                        
                        
                        SecureField(text: $model.confirmPassword, label: {
                            Text("Confirm Password")
                        })
                        
                        TextField(text: $model.name, label: {
                            Text("Name")
                        })
                    }
                    .autocapitalization(.none)
                    
                    Section {
                        Button(action: model.signUpEvent) {
                            if(!model.isLoading) {
                                Text("Register")
                            } else {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            }
                        }.disabled(model.isLoading)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(Text("Registration"))
        .alert("Successful", isPresented: $model.isSuccessful, actions: {
            Button("Confirm", action: {
                mode.wrappedValue.dismiss()
            })
        }, message: {
            Text(model.successfulMsg)
        })
        .alert("Error", isPresented: $model.isError, actions: {}, message: {
            Text(model.errorMsg)
        })
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
