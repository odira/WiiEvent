//
//  Plan.swift
//  WiiEvent
//
//  Created by Vladimir Ilin on 14.07.2025.
//

import SwiftUI

// MARK: - Plan struct definition

public struct Plan: Hashable, Codable, Identifiable {
    public var id: Int        // 0
    public var plan: String   // 1
    public var name: String?  // 2
    public var note: String?  // 3
    
    public init(
        id: Int = 0,          // 0
        plan: String = "",    // 1
        name: String? = nil,  // 2
        note: String? = nil   // 3
    ) {
        self.id = id          // 0
        self.plan = plan      // 1
        self.name = name      // 2
        self.note = note      // 3
    }
}

// MARK: - Plan struct extension

public extension Plan {
    
    var color: Color {
        switch self.plan {
            case "ЦП СОиМО": return .blue
            case "ЦП КВ": return .orange
            case "ЦП БАС": return .yellow
            case "ЦП ОС": return .green
            case "ФЦП": return .red
            default: return .gray
        }
    }
    
    func transparant(for plan: Plan) -> some View {
        Text(plan.plan)
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(plan.color)
//            .bold()
            .padding(3)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(plan.color, lineWidth: 1)
            }
    }
}

// MARK: - Plan Example

#if DEBUG
public extension Plan {
    
    static let example = samples[0]
    
    static let samples: [Plan] = [
        Plan(
            id: 1,              // 0
            plan: "ЦП СОиМО",   // 1
            name: "План 2026",  // 2
            note: "План NOTE"   // 3
        )
    ]
    
}
#endif
