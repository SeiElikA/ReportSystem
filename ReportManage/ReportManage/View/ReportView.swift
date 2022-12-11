//
//  ReportView.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/11.
//

import SwiftUI

struct ReportView: View {
    @StateObject private var model = ReportViewModel()

    var body: some View {
        ZStack {
            if(model.isLoading) {
                ProgressView()
            } else {
                GeometryReader { gSize in
                    VStack {
                        HStack {
                            Picker("Account", selection: $model.selectAccount, content: {
                                ForEach(model.allAccountList, id: \.self) { name in
                                    Text(name)
                                }
                            })
                            .frame(width: gSize.size.width * 0.3)
                            
                            Picker("Date", selection: $model.selectDate, content: {
                                ForEach(model.allDateList, id: \.self) { date in
                                    Text(date)
                                }
                            })
                            .frame(width: gSize.size.width * 0.3)
                            
                            Spacer()
                        }
                        .onChange(of: model.selectDate, perform: { _ in
                            model.filterChangeEvent()
                        })
                        .onChange(of: model.selectAccount, perform: { _ in
                            model.filterChangeEvent()
                        })
                        
                        List {
                            ForEach(model.filterList.map({$0.dateTime}), id: \.self, content: { datetime in
                                Section(datetime) {
                                    ForEach(model.filterList.filter({$0.dateTime == datetime})) { report in
                                        VStack {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text("Account")
                                                        .foregroundColor(.gray.opacity(0.5))
                                                        .font(.system(size: 14))
                                                    
                                                    Text(report.account.name)
                                                        .font(.system(size: 18))
                                                        .padding(.bottom, 12)
                                                    
                                                    Text("Work Detail")
                                                        .foregroundColor(.gray.opacity(0.5))
                                                        .font(.system(size: 14))
                                                    
                                                    Text(report.reportDetail.map({ detail in
                                                        let index = report.reportDetail.firstIndex(of: detail) ?? 0
                                                        
                                                        return "\(index+1). \(detail.content)"
                                                    }).joined(separator: "\n"))
                                                    .font(.system(size: 16))
                                                    .padding(.bottom, 12)
                                                    
                                                    if(!report.imageDetail.isEmpty) {
                                                        Text("Work Image Detail")
                                                            .foregroundColor(.gray.opacity(0.5))
                                                            .font(.system(size: 14))
                                                    }
                                                    
                                                    imageDetailListView(imgList: report.imageDetail)
                                                }
                                                Spacer()
                                            }
                                            
                                            Divider()
                                        }
                                    }
                                }
                            })
                        }
                    }
                    .padding(12)
                }
                .textSelection(.enabled)
            }
        }
        .onAppear {
            model.fetchReportList()
        }
    }
    
    func imageDetailListView(imgList: [ImageDetail]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(imgList) { imgDetail in
                    AsyncImage(url: URL(string: Global.baseUrl + imgDetail.imgPath)!, content: { img in
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .cornerRadius(4)
                            .onTapGesture(count: 2, perform: {
                                saveImage(img: img, imageDetail: imgDetail)
                            })
                    }, placeholder: {
                        Rectangle()
                            .fill(Color("Gray"))
                            .frame(width: 52, height: 52)
                            .overlay(ProgressView())
                            .cornerRadius(4)
                    })
                }
            }
        }

    }
    
    func saveImage(img: Image, imageDetail: ImageDetail) {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png, .jpeg]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save image"
        savePanel.message = "Choose a folder to store the image."
        savePanel.nameFieldLabel = "Image file name:"
        let response = savePanel.runModal()
        if response == .OK {
            let saveUrl = savePanel.url
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: URL(string: Global.baseUrl + imageDetail.imgPath)!)
                    try data.write(to: saveUrl!)
                    DispatchQueue.main.async {
                        model.isSuccessful = true
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
