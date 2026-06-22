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
    @State private var note: String?
    @State private var letterNumReceiver: String?
    @State private var letterDateReceiver: Date? = Date.now
    
    var body: some View {
        NavigationStack {
            VStack {
                HistoryFieldsEditor(date: $date, history: $history, note: $note, letterNumReceiver: $letterNumReceiver, letterDateReceiver: $letterDateReceiver)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        role: .confirm,
                        action: {
                            Task {
                                await historyModel.sqlINSERT(eventID: self.eventId, date: self.date, history: self.history, note: self.note ?? "", letterNumReceiver: self.letterNumReceiver, letterDateReceiver: self.letterDateReceiver)
                            }
                            dismiss()
                        }, label: {
                            Text("Save")
                        })
                }
            }
        }
    }
}


#Preview {
    HistoryAddView(eventId: Event.example.id)
        .environmentObject(HistoryModel.example)
}
