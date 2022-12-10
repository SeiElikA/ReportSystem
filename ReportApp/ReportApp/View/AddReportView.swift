//
//  AddReportView.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/9.
//

import SwiftUI
import PhotosUI

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
            
            Section("Add work item", content: {
                TextField("Input...", text: $model.input)
                    .autocapitalization(.none)
                
                Button("Add Work Item", action: model.addWorkItemEvent)
            })
            
            Section("Add work image", content: {
                if(!model.imageList.isEmpty) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(model.imageList, id: \.self) { imgData in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: UIImage(data: imgData)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(8)
                                    
                                    Button(action: {
                                        withAnimation {
                                            model.imageList.removeAll(where: {$0 == imgData})
                                        }
                                    }, label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.red)
                                    })
                                    .padding(12)
                                }
                            }
                        }
                    }
                }
                
                PhotosPicker("Add Work Image", selection: $model.selectImageItem, matching: .any(of: [.images]))
            })
            
            Section(header: Text(""), footer: Text("You can't edit it after send report").foregroundColor(.red)) {
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
        .onChange(of: model.selectImageItem, perform: { item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self) {
                    DispatchQueue.main.async {
                        withAnimation {
                            model.imageList.append(data)
                        }
                    }
                }
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
