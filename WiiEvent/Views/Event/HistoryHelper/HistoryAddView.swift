//
//  HistorySheetAdd.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 11.09.2024.
//

import SwiftUI

struct HistoryAddView: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var historyModel: HistoryModel
    
    let eventId: Int
    
    @State private var date: Date = Date.now
    @State private var history: String = ""
    @State private var note: String = ""
    
//    init(for event: Event) {
//        self.eventId = event.id
//    }
    
//    @State private var showDatePicker = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HistoryFieldsEditor(date: $date, history: $history, note: $note)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(role: .destructive, action: { dismiss() }) {
                        Text("Close")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await historyModel.sqlINSERT(eventId: self.eventId, date: self.date, history: self.history, note: self.note)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    HistoryAddView(eventId: Event.example.id)
        .environmentObject(HistoryModel.example)
        .frame(width: 600, height: 800)
}
