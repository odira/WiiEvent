//
//  Profile.swift
//  WiiPlanData
//
//  Created by Vladimir Ilin on 15.01.2024.
//

import Foundation

struct Profile {
    var event: String
    var prefersNotifications = true
    var phasePhoto = Phase.planned
    var goalDate = Date()
    
    static let `default` = Profile(event: "monrepo")
    
    enum Phase: String, CaseIterable, Identifiable {
        case completed = "🧎"
        case pending = "🏃"
        case planned = "🧍"
        case undefined = "🧑‍🦯"
        
        var id: String { rawValue }
    }
}
