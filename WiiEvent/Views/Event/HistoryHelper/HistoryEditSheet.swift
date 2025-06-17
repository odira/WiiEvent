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
    
    @EnvironmentObject var historyModel: HistoryModel

    let historyId: Int
    
//    var history: History {
//        historyModel.findHistoryById(id: historyId)!
//    }
    var history: History
    
    var body: some View {
        //        NavigationStack {
        //            ScrollView {
        
        VStack {
//            var history = historyModel.findHistoryById(id: historyId)
//            HistoryFieldsEditor(date: $history.date, history: $history.history, note: $history.note)
//                .padding()
            
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
    } // body
}


//#Preview {
//    HistoryEditSheet(history: History.example)
//        .environmentObject(HistoryModel.example)
//        #if os(macOS)
//        .frame(width: 600, height: 800)
//        #endif
//}
