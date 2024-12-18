//
//  JustificationView.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 26.09.2024.
//

import SwiftUI


struct JustificationView: View {
    let justification: String?
    
    init(for justification: String?) {
        self.justification = justification
    }
    
    var body: some View {
        VStack {
            Text("Обоснование выполнения мероприятия")
                .font(.title)
                .multilineTextAlignment(.center)
                .bold()
            Text(justification ?? "")
                .font(.subheadline)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    JustificationView(for: "")
}
