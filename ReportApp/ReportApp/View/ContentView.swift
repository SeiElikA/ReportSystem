//
//  ContentView.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = MainViewModel()
    
    var body: some View {
        ZStack {
            ZStack {
                List {
                    ForEach(model.reportList, id: \.id) { report in
                        NavigationLink(destination: ReportDetailView(reportContent: report), label: {
                            HStack(alignment: .top, spacing: 8) {
                                VStack(spacing: 0) {
                                    if(report.dateTime == model.todayString) {
                                        Circle()
                                            .strokeBorder(Color("LightRed"), lineWidth: 3)
                                            .frame(width: 28, height: 28)
                                            .overlay(Circle()
                                                .fill(Color("LightRed"))
                                                .frame(width: 18, height: 18))
                                    } else {
                                        Circle()
                                            .strokeBorder(.gray.opacity(0.3), lineWidth: 3)
                                            .frame(width: 28, height: 28)
                                    }
                                    
                                    if(model.reportList.firstIndex(of: report) != model.reportList.count - 1) {
                                        Rectangle()
                                            .fill(.gray.opacity(0.3))
                                            .frame(maxWidth: 4, maxHeight: .infinity)
                                    } else {
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(maxWidth: 4, maxHeight: .infinity)
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(report.dateTime)
                                        .font(.title2)
                                        .frame(height: 32)
                                    
                                    HStack {
                                        if(report.reportDetail.count > 4) {
                                            Text(report.reportDetail.prefix(4).map({ detail in
                                                let index = report.reportDetail.firstIndex(of: detail) ?? 0
                                                
                                                return "\(index+1). \(detail.content)"
                                            }).joined(separator: "\n") + "\n ...")
                                        } else {
                                            Text(report.reportDetail.map({ detail in
                                                let index = report.reportDetail.firstIndex(of: detail) ?? 0
                                                
                                                return "\(index+1). \(detail.content)"
                                            }).joined(separator: "\n"))
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(Color("Gray"))
                                    .cornerRadius(12)
                                }
                                
                            }
                            .padding(.top, -10)
                        })
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .refreshable(action: {
                    model.fetchReportRecord()
                })
                
                if(model.reportList.isEmpty) {
                    VStack {
                        Image("img_empty")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 52)
                        
                        Text("Click add button to \nrecord a new report today")
                            .font(.system(.headline))
                            .multilineTextAlignment(.center)
                    }
                }
                
                NavigationLink("", destination: LoginView(), isActive: $model.isLogout)
            }
            .refreshable(action: {
                model.fetchReportRecord()
            })
            .onAppear {
                model.fetchReportRecord()
            }
            .listStyle(.grouped)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: HStack {
                NavigationLink(destination: AddReportView(), label: {
                    Image(systemName: "plus")
                }).disabled(model.isLoading)
                
                Button(action: {
                    model.isLogoutAlert = true
                }, label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }).disabled(model.isLoading)
            })
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(Text("Report"))
            .alert("Logout", isPresented: $model.isLogoutAlert, actions: {
                Button(action: model.logoutEvent) {
                    Text("Logout")
                }
                Button(action: {
                    model.isLogoutAlert = false
                }) {
                    Text("Cancel")
                }
            }, message: {
                Text("Do you want logout")
            })
            
            if model.isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content: {
            ContentView()
        })
    }
}
