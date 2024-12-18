//
//  DescriptionView.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 28.11.2024.
//

import SwiftUI


struct DescriptionView: View {
    let description: String?
    
    init(for description: String?) {
        self.description = description
    }
    
    var body: some View {
        VStack {
            Text("Описание выполняемых работ по мероприятию")
                .font(.title)
                .multilineTextAlignment(.center)
                .bold()
            Text(description ?? "")
                .font(.subheadline)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DescriptionView(for: "")
}
