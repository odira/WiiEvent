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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
//                            await historyModel.sqlUPDATE(
//                                id: history.id,
//                                date: history.date,
//                                history: history.history,
//                                note: history.note ?? "",
//                                letter: history.letter ?? "",
//                                letterDate: history.letterDate ?? Date())
                            
                            await historyModel.sqlUPDATE(history: history)
                            
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryEditView(history: History.example)
        .environmentObject(HistoryModel())
}
