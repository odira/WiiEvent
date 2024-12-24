//
//  HistorySheetEdit.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 05.09.2024.
//

import SwiftUI


// MARK: -- HistorySheetEdit definition

public struct HistoryEditSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var historyModel: HistoryModel

    @State var history: History
    
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                
                DatePicker(
                    "Выберите дату...",
                    selection: $history.date,
                    displayedComponents: [.date]
                )
                
                TextEditor(text: $history.history)
                    .foregroundStyle(.primary)
                    .padding()
                
                TextField("Введите примечание...", text: $history.note)
                
            }
            .padding()
            
            #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close", role: .destructive, action: {
                        dismiss()
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: {
                        Task {
                            await historyModel.sqlUPDATE(history: history)
                            await historyModel.fetch()
                            dismiss()
                        }
                    })
                }
            } // .toolbar
            #endif
            
        }
    } // body
}


#Preview {
    HistoryEditSheet(history: History.example)
        .environmentObject(HistoryModel.example)
}
