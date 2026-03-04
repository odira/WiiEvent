//
//  InfoDetails.swift
//  WiiEvent
//
//  Created by Vladimir Ilin on 20.11.2025.
//

import SwiftUI

struct InfoDetails: View {
    @Environment(\.openWindow) var openWindow
    
    @EnvironmentObject var infoModel: InfoModel
    
    let info: Info
    
    var body: some View {
        VStack {
            
            HStack {
                Text(info.date, style: .date)
                    .font(.title2)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.glassProminent)
            
            Text(LocalizedStringKey(info.info))
//                .lineSpacing(8)
                .frame(minHeight: 180)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .fixedSize(horizontal: false, vertical: false)
                .textEditorStyle(.plain)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            HStack {
                Button("Edit") {
                    openWindow(id: "info-edit", value: info)
                }
                Button("Delete") {
                    Task { await infoModel.sqlDELETE(id: info.id) }
                }
            }
            .buttonStyle(.glassProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow.opacity(0.1))
    }
}

#Preview {
    InfoDetails(info: Info.example)
        .environmentObject(InfoModel.example)
        #if os(macOS)
        .frame(width: 600, height: 800)
        #endif
}
