//
//  HistoryFieldsEditor.swift
//  WiiEventMac
//
//  Created by Wiipuri Developer on 18.06.2025.
//

import SwiftUI

struct HistoryFieldsEditor: View {
    @Binding var date: Date
    @Binding var history: String
    @Binding var note: String?
    @Binding var letterNumReceiver: String?
    @Binding var letterDateReceiver: Date?
    
//    init(date: Date, history: String, note: String, letter: String, letterDate: Date) {
//        self.date = date
//        self.history = history
//        self.note = note
//        self.letter = letter
//        self.letterDate = letterDate
//    }
    
    var body: some View {
        ScrollView {
            VStack {
                DatePicker(
                    "Select a Date",
                    selection: Binding(
                        get: { self.letterDateReceiver ?? Date() },
                        set: { self.letterDateReceiver = $0 }
                    ),
                    displayedComponents: [.date]
                )
                    .datePickerStyle(.compact)
                    .contentShape(Rectangle())
                    .font(.callout)
                
                TextEditor(
                    text: Binding(
                        get: { self.letterNumReceiver ?? "" },
                        set: { self.letterNumReceiver = $0 }
                    )
                )
                    .lineLimit(1)
                    .font(.callout)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                    }
                    .frame(height: 100)
            }
            
            DatePicker(
                "Select a Date",
                selection: $date,
                displayedComponents: [.date]
            )
                .datePickerStyle(.compact)
                .contentShape(Rectangle())
            
            TextEditor(text: $history)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 1)
                }
                .frame(height: 200)
            
            
            TextEditor(
                text: Binding(
                    get: { self.note ?? "" },
                    set: { self.note = $0 }
                )
            )
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 1)
                }
                .frame(height: 200)
        }
        .padding()
    }
}

#Preview {
    HistoryFieldsEditor(
        date: .constant(History.example.date),
        history: .constant(History.example.history),
        note: .constant(History.example.note!),
        letterNumReceiver: .constant(History.example.letterNumReceiver!),
        letterDateReceiver: .constant(History.example.letterDateReceiver!)
    )
}
