//
//  EventFilterView.swift
//  WiiEvent
//
//  Created by Vladimir Ilin on 10.07.2025.
//

import SwiftUI

// MARK: - EventModelFilter View definition

struct EventModelFilterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var eventModel: EventModel
    @EnvironmentObject private var planModel: PlanModel
    @EnvironmentObject private var dealModel: DealModel
    @EnvironmentObject private var eventModelFilter: EventModelFilter
    
//    @State private var planIdFilter: Int? = nil
    @State private var dealStatusFilter: Int? = nil
    @State private var dealFilter: String = ""
    
    @FocusState private var searchFieldFocusState: Bool
    
    var body: some View {
        ScrollView {
            cityBlock().padding()
            planIdBlock().padding()
            dealStatusBlock().padding()
            dealIdBlock().padding()
            eventIsValidBlock().padding()
            showIsOptionBlock().padding()
        
            HStack {
                Spacer()
                Button("Search") {
                    update()
                    print("SEARCH")
                }
                Button("Done") {
                    update()
                    dismiss()
                }
                Button("Close") {
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .onAppear {
            searchFieldFocusState = true
        }
    }
    
    private func update() {
        eventModelFilter.filteredEvents = eventModelFilter.filterEvents(eventModel.events)
    }
}

// MARK: - EventModelFilter View Preview

#Preview {
    EventModelFilterView()
        .environmentObject(EventModel.example)
        .environmentObject(EventModelFilter.shared)
        .environmentObject(PlanModel.example)
        .environmentObject(DealModel.example)
}

// MARK: - EventModelFilter Visual Blocks

extension EventModelFilterView {
    
    // city
    private func cityBlock() -> some View {
        VStack(alignment: .leading) {
            Text("Город")
            HStack {
                TextField("Search", text: $eventModelFilter.city)
                    .focused($searchFieldFocusState)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Clear") {
                    eventModelFilter.city = ""
                    searchFieldFocusState = true
                }
                .keyboardShortcut("c", modifiers: [.command])
            }
        }
    }
    
    // planId
    private func planIdBlock() -> some View {
        VStack(alignment: .leading) {
            Text("Выберите план")
            HStack {
                Picker("", selection: $eventModelFilter.planId) {
                    ForEach(planModel.plans) { plan in
                        Text(plan.plan).tag(plan.id)
                    }
                }
                .pickerStyle(.segmented)
                Spacer()
            }
        }
    }
    
    // dealStatus
    private func dealStatusBlock() -> some View {
        VStack(alignment: .leading ) {
            Text("Статус договора")
            HStack {
                Picker("", selection: $dealStatusFilter) {
                    Text("Все").tag(0)
                    Text("Активен").tag(1)
                    Text("Закрыт").tag(2)
                }
                .pickerStyle(.segmented)
                Spacer()
            }
        }
    }
    
    // dealId
    private func dealIdBlock() -> some View {
        VStack(alignment: .leading) {
            Label("Номер Договора", systemImage: "magnifyingglass")
            HStack {
                TextField("Договор", text: $eventModelFilter.dealNumber)
                    .textFieldStyle(.roundedBorder)
                Button("Clear") {
                    eventModelFilter.dealNumber = ""
                }
                
//                if !dealFilter.isEmpty {
//                    if let eventIds = dealModel.findEventIdsByDeal(dealFilter) {
//                        eventModelFilter.eventIds = eventIds
//                    }
//                }
            }
        }
    }
    
    private func eventIsValidBlock() -> some View {
        HStack {
            Toggle(isOn: $eventModelFilter.isValid) {
                Text("Показывать только валидные")
            }
//            .toggleStyle(.)
            Spacer()
        }
    }
    
    private func showIsOptionBlock() -> some View {
        HStack {
            Toggle(isOn: $eventModelFilter.isOption) {
                Text("Показывать опцион")
            }
//            .toggleStyle(.checkbox)
            Spacer()
        }
    }
}
