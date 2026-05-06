//
//  HistoryRow.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 15.06.2025.
//

import SwiftUI

struct HistoryListRowView: View {
    @EnvironmentObject var historyModel: HistoryModel

    let history: History
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack {
                HStack {
                    Text(dateFormatter.string(from: history.date))
                        .foregroundStyle(.blue)
                        .bold()
                        .background(.clear)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.clear)
                                .stroke(Color.blue, lineWidth: 1)
                        }
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 1)
                            .foregroundStyle(.blue)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 10, height: 10)
                            .foregroundStyle(.orange)
                            .padding()
                    }
                }
                .padding(.leading, 10)
            }
            
            
            VStack(alignment: .leading) {
                if let letter = history.letter {
                    HStack {
                        Text(letter)
                        Text(dateFormatter.string(from: history.letterDate!))
                    }
                    .font(.footnote)
                    .padding(5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(.clear)
                            .stroke(Color.blue, lineWidth: 1)
                    }
                    .padding(.trailing, 10)
                }
                
                HStack {
                    Text(history.history)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.clear)
                                .stroke(Color.blue, lineWidth: 1)
                        }
                }
                .frame(maxWidth: .infinity)
                .padding(.trailing, 10)
                .padding(.bottom, 10)
            }
        }
        .font(.system(.callout, design: .monospaced))
    }
}

#Preview(traits: .fixedLayout(width: 900, height: 300)) {
    HistoryListRowView(history: History.example)
        .environmentObject(EventModel())
        .environmentObject(HistoryModel())
}
