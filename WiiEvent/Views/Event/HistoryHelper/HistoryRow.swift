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
            
            VStack(alignment: .leading) {
                Text(history.history)
                    .background(.clear)
                    .multilineTextAlignment(.leading)
                    .padding()
            }
            
            Spacer()
            
            Button("Edit") {
                
            }
            .padding()
        }
        .font(.system(.callout, design: .monospaced))
    }
}

#Preview {
    HistoryRow(history: History.example)
}
