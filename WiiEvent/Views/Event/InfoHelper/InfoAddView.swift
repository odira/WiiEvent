//
//  InfoAddSheet.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 21.10.2025.
//

import SwiftUI

struct InfoAddView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var infoModel: InfoModel
    
    let eventId: Int
    
    @State private var date: Date = Date.now
    @State private var info: String = ""
    @State private var note: String = ""
    
    var body: some View {
        VStack {
            InfoFieldsEditor(date: $date, info: $info, note: $note)
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
                        await infoModel.sqlINSERT(eventId: self.eventId, date: self.date, info: self.info, note: self.note)
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    InfoAddView(eventId: Event.example.id)
        .environmentObject(InfoModel.example)
        .frame(width: 600, height: 800)
}
