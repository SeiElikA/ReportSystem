//
//  AccountView.swift
//  ReportManage
//
//  Created by 葉家均 on 2022/12/10.
//

import SwiftUI

struct AccountView: View {
    @StateObject private var model = AccountViewModel()

    var body: some View {
        ZStack {
            if !model.isLoading {
                Table(model.accountList, selection: $model.selectionId) {
                    TableColumn("ID") {
                        Text("\($0.id)")
                    }
                    TableColumn("Name", value: \.name)
                    TableColumn("Email", value: \.email)
                    TableColumn("Password", value: \.password)
                }
                .onChange(of: model.selectionId, perform: { id in
                    
                })
            } else {
                ProgressView()
            }
        }
        .onAppear {
            model.fetchAccountList()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
