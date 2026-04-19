//
//  HistoryEditView.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 05.09.2024.
//

import SwiftUI

struct HistoryEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var historyModel: HistoryModel

    @State var history: History
    
    var body: some View {
        VStack {
//            HistoryFieldsEditor(date: $history.date, history: $history.history, note: $history.note)
//                .padding()
            
        }
        
        #if os(macOS)
            HStack {
                Button("Save") {
                    Task {
                        await historyModel.sqlUPDATE(history: history)
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
    HistoryEditView(history: History.example)
        .environmentObject(HistoryModel())
        #if os(macOS)
        .frame(width: 600, height: 800)
        #endif
}
