//
//  Information.swift
//  WiiEvent
//
//  Created by Vladimir Ilin on 22.08.2025.
//

import SwiftUI

// MARK: - Info struct definition

public struct Info: Hashable, Codable, Identifiable {
    
    public var id: Int              // 0
    public var info: String         // 1
    public var date: Date           // 2
    public var eventID: Int         // 3
    public var note: String         // 4
    
    public init(
        id: Int,                    // 0
        info: String,               // 1
        date: Date,                 // 2
        eventID: Int,               // 3
        note: String                // 4
    ) {
        self.id = id                // 0
        self.info = info            // 1
        self.date = date            // 2
        self.eventID = eventID      // 3
        self.note = note            // 4
    }
}

// MARK: - Info example

#if DEBUG
public extension Info {
    static let example = samples[0]
    static let samples: [Info] = [
        Info(
            id: -1000,
            info: "Information Test",
            date: Date.now,
            eventID: 12,
            note: "Information Note Test"
        )
    ]
}
#endif
