//
//  ContentView.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            NavigationLink(destination: AccountView(), label: {
                Label {
                    Text("Exist Account")
                } icon: {
                    Image(systemName: "person.circle.fill")
                }

            })
            
            NavigationLink(destination: ReportView(), label: {
                Label {
                    Text("Report Record")
                } icon: {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                }
            })
            
            NavigationLink(destination: AllImageView(), label: {
                Label {
                    Text("All Image")
                } icon: {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
