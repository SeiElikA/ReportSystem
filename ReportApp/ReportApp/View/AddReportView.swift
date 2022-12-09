//
//  AddReportView.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/9.
//

import SwiftUI

struct AddReportView: View {
    @StateObject private var model = AddReportViewModel()
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        List {
            Section("Today's work item", content: {
                if(model.todayWorkItemList.isEmpty) {
                    Text("Empty")
                        .opacity(0.3)
                } else {
                    ForEach(model.todayWorkItemList, id: \.self, content: { item in
                        Text("\((model.todayWorkItemList.firstIndex(of: item) ?? 0) + 1). \(item)")
                    }).onDelete(perform: model.removeWorkItem(indexSet:))
                }
            })
            
            Section("Add Item", content: {
                TextField("Input...", text: $model.input)
                    .autocapitalization(.none)
                
                Button("Add Work Item", action: model.addWorkItemEvent)
            })
            Section {
                if model.isLoading {
                    HStack {
                        ProgressView()
                    }.frame(maxWidth: .infinity)
                } else {
                    Button("Send Report", action: model.sendReportEvent)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Add Report"))
        .alert("Error", isPresented: $model.isError, actions: {}, message: {
            Text(model.errorMsg)
        })
        .alert("Successful", isPresented: $model.isSuccessful, actions: {}, message: {
            Text(model.successfulMsg)
        })
        .onChange(of: model.isBack, perform: {
            if($0) {
                mode.wrappedValue.dismiss()
            }
        })
    }
}

struct AddReportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content:  {
            AddReportView()
        })
    }
}
