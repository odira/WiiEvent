//
//  HistorySheetAdd.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 11.09.2024.
//

import SwiftUI

struct HistoryAddView: View {
//    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var historyModel: HistoryModel
    
    let eventId: Int
    
    @State private var date: Date = Date.now
    @State private var history: String = ""
    @State private var note: String?
    @State private var letter: String?
    @State private var letterDate: Date? = Date.now
    
    var body: some View {
        NavigationStack {
            VStack {
                HistoryFieldsEditor(date: $date, history: $history, note: $note, letter: $letter, letterDate: $letterDate)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        role: .confirm,
                        action: {
                            Task {
                                await historyModel.sqlINSERT(eventId: self.eventId, date: self.date, history: self.history, note: self.note ?? "", letter: self.letter, letterDate: self.letterDate)
                                
//                                dismiss()
                            }
                        }, label: {
                            Text("Add")
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
