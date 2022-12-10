//
//  AllImageView.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/10.
//

import SwiftUI

struct AllImageView: View {
    @StateObject private var model = AllImageViewModel()
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            if model.isLoading {
                ProgressView()
            } else {
                GeometryReader { gSize in
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, spacing: 20) {
                            ForEach(model.imgList) { imgDetail in
                                AsyncImage(url: URL(string: Global.baseUrl + imgDetail.imgPath)!, content: { img in
                                    Button(action: {
                                        saveImage(img: img, imageDetail: imgDetail)
                                    }, label: {
                                        img
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: gSize.size.width / 6, height: gSize.size.width / 6)
                                    })
                                    .buttonStyle(.borderless)
                                }, placeholder: {
                                    Rectangle()
                                        .fill(Color("Gray"))
                                        .frame(width: gSize.size.width / 6, height: gSize.size.width / 6)
                                        .overlay(ProgressView())
                                })
                            }
                            
                        }
                    }
                }
            }
        }.onAppear {
            model.fetchImgList()
        }
        .alert("Successful", isPresented: $model.isSuccessful, actions: {
            Button(action: {
                
            }, label: {
                Text("Confirm")
            })
        })
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

struct AllImageView_Previews: PreviewProvider {
    static var previews: some View {
        AllImageView()
    }
}
