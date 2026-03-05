//
//  EventMFilter.swift
//  WiiEvent
//
//  Created by Vladimir Ilin on 17.07.2025.
//

import SwiftUI

public class EventModelFilter: ObservableObject {
    @Published public var planId: Int? = nil
    @Published public var city: String = ""
    @Published public var eventIds: [Int]? = nil
    @Published public var dealNumber: String = ""
    @Published public var isChanged: Bool = false
    @Published public var isValid: Bool = true
    @Published public var isOption: Bool = false
    
    @Published public var filteredEvents: [Event] = []
    
    static let shared = EventModelFilter()
    
    init() {
        self.reset()
    }
    
    func reset() {
        self.planId = nil
        self.city = ""
        self.eventIds = nil
        self.dealNumber = ""
        self.isChanged = false
        self.isValid = true
    }
    
    func filterEvents(_ events: [Event]) -> [Event] {
        self.isChanged = false
        
        var filteredEvents = events
        
        // eventId
        if let eventIds {
            filteredEvents = filteredEvents.filter {
                eventIds.contains($0.id)
            }
        }
        
        // planId
        if let planId {
            filteredEvents = filteredEvents.filter {
                $0.planId == planId
            }
        }
        
        // city
        if !city.isEmpty {
            filteredEvents = filteredEvents.filter {
                $0.city!.lowercased().contains(city.lowercased())
            }
        }
        
        // dealNumber
        if !dealNumber.isEmpty {
//            if let eventIds = dealModel.findEventIdsByDealNumber(dealNumber) {
//                self.eventIds = eventIds
//            }
        }
        
        if self.isValid {
            filteredEvents = filteredEvents.filter {
                $0.isValid == true
            }
        }
        
        if !self.isOption {
            filteredEvents = filteredEvents.filter {
                $0.isOption == false
            }
        }
        
        return filteredEvents
    }
}

