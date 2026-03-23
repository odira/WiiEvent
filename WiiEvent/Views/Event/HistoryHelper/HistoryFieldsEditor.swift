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
    @Binding var note: String
    
    var body: some View {
        VStack {
            ScrollView {
                DatePicker("Select a Date", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .contentShape(Rectangle())
                
                TextEditor(text: $history)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                    }
                    .frame(height: 200)
                
                TextEditor(text: $note)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                    }
                    .frame(height: 200)
            }
            .padding()
        }
    }
}

#Preview {
    HistoryFieldsEditor(
        date: .constant(History.example.date),
        history: .constant(History.example.history),
        note: .constant(History.example.note)
    )
}
