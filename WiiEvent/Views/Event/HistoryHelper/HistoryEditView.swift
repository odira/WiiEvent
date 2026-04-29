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
        NavigationStack {
            VStack {
                HistoryFieldsEditor(date: $history.date, history: $history.history, note: $history.note, letter: $history.letter, letterDate: $history.letterDate)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await historyModel.sqlINSERT(eventId: history.id, date: history.date, history: history.history, note: history.note ?? "", letter: history.letter ?? "", letterDate: history.letterDate ?? Date())
                            
                            dismiss()
                        }
                    }
                }
            }
        }
        
//        #if os(macOS)
//            HStack {
//                Button("Save") {
//                    Task {
//                        await historyModel.sqlUPDATE(history: history)
//                        dismiss()
//                    }
//                }
//                Spacer()
//                Button("Close") {
//                    dismiss()
//                }
//            }
//            .buttonStyle(.borderedProminent)
//            .padding()
//        #endif
    }
}

#Preview {
    HistoryEditView(history: History.example)
        .environmentObject(HistoryModel())
        #if os(macOS)
        .frame(width: 600, height: 800)
        #endif
}
