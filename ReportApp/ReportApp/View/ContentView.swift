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
                        
                    }
                }
            }
            
            NavigationLink("", destination: LoginView(), isActive: $model.isLogout)
        }
        .onAppear {
            model.fetchReportRecord()
        }
        .listStyle(.insetGrouped)
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
        NavigationView {
            ContentView()
        }
    }
}
