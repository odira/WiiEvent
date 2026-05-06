//
//  InfoEditView.swift
//  WiiEventMac
//
//  Created by Vladimir Ilin on 20.11.2025.
//

import SwiftUI

struct InfoEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var infoModel: InfoModel

    @State var info: Info
    
    var body: some View {
        NavigationStack {
            VStack {
                InfoFieldsEditor(date: $info.date, info: $info.info, note: $info.note)
            }
            .navigationTitle("Редактирование справочной информации")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        Task {
                            await infoModel.sqlUPDATE(info: info)
                            
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    InfoEditView(info: Info.example)
}
