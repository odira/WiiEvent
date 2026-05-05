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
    
    let eventID: Int
    
    @State private var date: Date = Date.now
    @State private var info: String = ""
    @State private var note: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                InfoFieldsEditor(date: $date, info: $info, note: $note)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await infoModel.sqlINSERT(eventId: self.eventID, date: self.date, info: self.info, note: self.note)
                            
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    InfoAddView(eventID: Event.example.id)
        .environmentObject(InfoModel.example)
        .frame(width: 600, height: 800)
}
