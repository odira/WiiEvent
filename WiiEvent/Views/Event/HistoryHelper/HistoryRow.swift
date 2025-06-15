//
//  HistoryRow.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 15.06.2025.
//

import SwiftUI

struct HistoryRow: View {
//    @EnvironmentObject var
    
    let history: History
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Text(dateFormatter.string(from: history.date))
                .font(.system(.caption2, design: .monospaced))
                .foregroundStyle(.blue)
                .bold()
                .background(.clear)
                .padding()
            
            ZStack {
                Rectangle()
                    .frame(width: 1)
                    .foregroundStyle(.blue)
                VStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 10, height: 10)
                        .foregroundStyle(.blue)
                        .padding()
                    Spacer()
                }
            }
//            .frame(width: 10)
//            .padding(.top, 0).padding(.bottom, 0)
            
            VStack(alignment: .leading) {
                Text(history.history)
                    .font(.system(.caption2, design: .monospaced))
                    .background(.clear)
                    .multilineTextAlignment(.leading)
                    .padding()
            }
            
            Spacer()
        }
    }
}

#Preview {
    HistoryRow(history: History.example)
}
