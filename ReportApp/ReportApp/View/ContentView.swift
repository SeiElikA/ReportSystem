//
//  ContentView.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = MainViewModel()
    let dateformatter = DateFormatter()
    
    var body: some View {
        ZStack {
            if(model.reportList.isEmpty) {
                VStack {
                    Image("img_empty")
                        .resizable()
                        .scaledToFit()
                    
                    Text("Click add button to \nrecord a new report today")
                        .font(.system(.headline))
                        .multilineTextAlignment(.center)
                }
            } else {
                List {
                    ForEach(model.reportList, id: \.id) { report in
                        HStack(alignment: .top, spacing: 8) {
                            VStack(spacing: 0) {
                                if(report.dateTime == dateformatter.string(from: .now)) {
                                    Circle()
                                        .strokeBorder(.black, lineWidth: 3)
                                        .frame(width: 32, height: 32)
                                        .overlay(Circle()
                                            .fill(.black)
                                            .frame(width: 24, height: 24))
                                } else {
                                    Circle()
                                        .strokeBorder(.black, lineWidth: 3)
                                        .frame(width: 32, height: 32)
                                }
                                
                                if(model.reportList.firstIndex(where: {$0 == report}) != model.reportList.count - 1) {
                                    Rectangle()
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
                                    Text(report.reportDetail.prefix(4).map({ detail in
                                        let index = report.reportDetail.firstIndex(where: {$0 == detail}) ?? 0
                                        
                                        return "\(index+1). \(detail.content)"
                                    }).joined(separator: "\n"))
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color("Gray"))
                                .cornerRadius(12)
                                
                                HStack {
                                    Spacer()
                                    Text("more >>")
                                        .font(.caption)
                                        .padding(.trailing, 8)
                                    
                                }
                            }
                            
                        }
                        .padding(.top, -10)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            
            NavigationLink("", destination: LoginView(), isActive: $model.isLogout)
        }
        .onAppear {
            //model.fetchReportRecord()
            dateformatter.dateFormat = "yyyy-MM-dd"
        }
        .listStyle(.grouped)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                
            }, label: {
                Image(systemName: "plus")
            })
            
            Button(action:  model.logoutEvent, label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
            })
        })
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(Text("Report"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content: {
            ContentView()
        })
    }
}
