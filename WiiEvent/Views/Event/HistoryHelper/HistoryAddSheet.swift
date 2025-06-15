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
    
    var body: some View {
        NavigationStack {
            
            VStack {
                ScrollView {
                    DatePicker(
                        "Введите дату...",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    TextEditor(text: $history)
                        .font(.caption2)
                        .frame(height: 50)
                        .foregroundStyle(.secondary)
                        .cornerRadius(5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1)
                        }
                    TextField("Введите примечание...", text: $note)
                        .font(.caption2)
                }
                .padding()
                
#if os(iOS)
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
                } // .toolbar
#endif
                
                #if os(macOS)
                HStack {
                    Button("Save") {
                        Task {
                            await historyModel.sqlINSERT(eventId: self.eventId, date: self.date, history: self.history, note: self.note)
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
    } // body
}


#Preview {
    HistoryAddView(eventId: Event.example.id)
        .environmentObject(HistoryModel.example)
        .frame(width: 600, height: 800)
}
