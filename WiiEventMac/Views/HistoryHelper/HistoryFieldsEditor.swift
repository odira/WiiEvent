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
//        VStack {
            ScrollView {
                DatePicker("Select a Date", selection: $date, displayedComponents: [.date])
//                    .datePickerStyle(FieldDatePickerStyle())
                    .datePickerStyle(.compact)
//                        .labelsHidden()
//                    .contentShape(Rectangle())
                .padding()
                
//                    Button("Date") {
//                        showDatePicker.toggle()
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .padding()
//
//                    if showDatePicker {
//                        DatePicker(
//                                            "",
//                                            selection: $date,
//                                            displayedComponents: .date
//                                        )
//                                        .labelsHidden()
//                                        .datePickerStyle(.graphical)
//                                        .frame(maxHeight: 400)
//                    }
                
                TextEditor(text: $history)
//                        .font(.caption2)
//                        .frame(height: 50)
//                        .foregroundStyle(.secondary)
//                        .cornerRadius(5)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(.black, lineWidth: 1)
//                        }
                    .frame(height: 200)
                
//                    TextField("Введите примечание...", text: $note)
//                        .font(.caption2)
                
                TextEditor(text: $note)
                    .frame(height: 200)
//            }
//            .padding()
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
