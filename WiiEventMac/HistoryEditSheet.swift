//
//  HistorySheetEdit.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 05.09.2024.
//

import SwiftUI


// MARK: -- HistorySheetEdit definition

struct HistoryEditSheet: View {
    @Environment(\.dismiss) var dismiss
    
//    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var historyModel: HistoryModel

    @State var history: History
    
//    private var history: History {
//        historyModel.findHistoryById(id: historyId)!
//    }
    
//    let eventId: Int
    
//    init(historyId: Int) {
//        self.historyId = historyId
//        
//        date = historyModel.findHistoryById(id: self.historyId)!.date
//        history = historyModel.findHistoryById(id: self.historyId)!.history
//        note = historyModel.findHistoryById(id: self.historyId)!.note
//    }
//    
//    @State private var date: Date = Date()
//    @State private var history: String = ""
//    @State private var note: String = ""
    
    var body: some View {
        //        NavigationStack {
        //            ScrollView {
        
        VStack {
            
//            var history = historyModel.findHistoryById(id: historyId)
            HistoryFieldsEditor(date: $history.date, history: $history.history, note: $history.note)
                .padding()
            
        }
        
//#if os(iOS)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button("Close", role: .destructive, action: {
//                    dismiss()
//                })
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Save", action: {
//                    Task {
//                        await historyModel.sqlUPDATE(history: history)
//                        await historyModel.fetch()
//                        dismiss()
//                    }
//                })
//            }
//        } // .toolbar
//#endif
        
        //        }
        #if os(macOS)
        HStack {
            Button("Save") {
                Task {
//                    await historyModel.sqlINSERT(eventId: self.eventId, date: self.date, history: self.history, note: self.note)
                    await historyModel.sqlUPDATE(history: history)
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
    } // body
}


#Preview {
    HistoryEditSheet(history: History.example)
//        .environmentObject(EventModel.example)
        .environmentObject(HistoryModel())

        #if os(macOS)
        .frame(width: 600, height: 800)
        #endif
}
