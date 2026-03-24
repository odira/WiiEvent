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
        VStack {
            InfoFieldsEditor(date: $info.date, info: $info.info, note: $info.note)
                .padding()
            
        }
        
        #if os(macOS)
        HStack {
            Button("Save") {
                Task {
                    await infoModel.sqlUPDATE(info: info)
                    dismiss()
                }
            }
            Spacer()
            Button("Close") {
                dismiss()
            }
        }
        .buttonStyle(.borderedProminent)
        .padding()
        #endif
    }
}

#Preview {
    InfoEditView(info: Info.example)
        .environmentObject(InfoModel())
        #if os(macOS)
        .frame(width: 600, height: 800)
        #endif
}
