//
//  InfoFieldsEditor.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 21.10.2025.
//

import SwiftUI

struct InfoFieldsEditor: View {
    @Binding var date: Date
    @Binding var info: String
    @Binding var note: String
    
    var body: some View {
        ScrollView {
            DatePicker("Select a Date", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .padding()
            
            TextEditor(text: $info)
                .frame(height: 200)
            
            TextEditor(text: $note)
                .frame(height: 200)
        }
    }
}

#Preview {
    InfoFieldsEditor(
        date: .constant(Info.example.date),
        info: .constant(Info.example.info),
        note: .constant(Info.example.note)
    )
}
