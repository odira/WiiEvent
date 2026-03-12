//
//  Created by Wiipuri Developer on 30.10.2024.
//

import SwiftUI
import WiiKit

struct EventListView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var dealModel: DealModel
//    @EnvironmentObject var historyModel: HistoryModel
    @EnvironmentObject var planModel: PlanModel
    @EnvironmentObject var eventModelFilter: EventModelFilter

    @State private var selection = Set<Event.ID>()
    @State private var isPresentedEventDetailsView: Bool = false
    
    // MARK: - Body view
    var body: some View {
        VStack {
            Table(of: Event.self, selection: $selection) {

                // city
                TableColumn(cityColumnHeader()) { event in
                    cityColumnContext(for: event)
                        .padding(15)
                }

                // event
                TableColumn(eventColumnHeader()) { event in
                    VStack(alignment: .leading) {
                        HStack {
                            event.statusTransparant(for: event)
                            if let plan = planModel.findPlanByID(id: event.planId) {
                                plan.transparant(for: plan)
                            }
                            if event.isOption {
                                event.isOptionTransparant(for: event)
                            }
                            Spacer()
                        }
                        
                        eventColumnContext(for: event)
                            .lineLimit(5)
                    }
                    .padding(15)
                }

                // _contract number_ & _date of conclusion_
                TableColumn(contractColumnHeader()) { event in
                    if let deals = dealModel.findDeals(byEventID: event.id) {
                        
                        if let deal = deals.first {
                            VStack(alignment: .leading, spacing: 5) {
                                
                                HStack {
                                    DealStatusTransparant(for: deal)
                                    Spacer()
                                }
                                
                                // Deal is planning & not concluded
                                if deal.isPlanning {
                                    Text(DateFormatter.planningMonth.string(from: deal.startingDate))
                                    
                                // Deal is concluded
                                } else {
                                    
                                    HStack {
                                        Text(deal.typeAbbr)
                                        Text("№ ")
                                        Text(deal.deal ?? "")
                                            .fontWeight(.bold)
                                            .foregroundStyle(.primary)
                                        
                                        if deals.count > 1 {
                                            Image(systemName: "list.bullet.circle")
                                                .foregroundColor(.orange)
                                        }
                                    }
                                    Text(DateFormatter.longDateFormatter.string(from: deal.startingDate))
                                    
                                    // Deal is completed
                                    if let endingDate = deal.endingDate {
                                        VStack(alignment: .leading) {
//                                            CompletedButton(isCompleted: .constant(true))
                                            Text(DateFormatter.longDateFormatter.string(from: endingDate))
                                        }
                                    }
                                    
                                }
                            }.padding(15)
                        }
                        
                    }
                }
                
                // Дата закрытия договора
//                TableColumn(Text("Дата закрытия договора").bold().foregroundStyle(.blue)) { event in  
//                    if let deals = dealModel.findDeals(byEventID: event.id) {
//                        if let deal = deals.first {
//                            if let endingDate = deal.endingDate {
//                                VStack(alignment: .leading) {
//                                    CompletedButton(isCompleted: .constant(true))
//                                    Text(DateFormatter.longDateFormatter.string(from: endingDate))
//                                }
//                            } else {
//                                EmptyView()
//                                
//                            }
//                        }
//                    }
//                }
                
                    // price
                    TableColumn(Text("Стоимость мероприятия, ₽ (руб)").bold().foregroundStyle(.blue)) { event in
                        Group {
                            Text((event.limitTotal ?? 0.0), format: .number) +
                            Text(" ")                                   +
                            Text("₽").fontWeight(.heavy)
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .width(ideal: 50)
                    
                    // contragent - subcontractor
                    TableColumn(Text("Подрядчик\nСубподрядчик").bold().foregroundStyle(.blue)) { event in
                        VStack(alignment: .leading, spacing: 7) {
                            if let contragent = event.contragent {
                                Text("\(contragent)")
                            }
                            if let subcontractor = event.subcontractor {
                                Text("\(subcontractor)")
                            }
                            EmptyView()
                        }
                        .padding(15)
                    }
                    
                    // senior
                    TableColumn(seniorColumnHeader()) { event in
                        if let senior = event.senior {
                            Text("\(senior)")
                        } else {
                            EmptyView()
                        }
                    }
                
                // equipment
                // phase
                // years
                // end_morder
                // event_description
                // is_completed
                // is_optional
                // justification
                // note
                // valid
                // limit_2020
                // limit_2021
                // limit_2022
                // limit_2023
                // limit_2024
                // limit_2025
                // limit_2026
                // limit_2027
                // limit_2028
                // limit_2029
                // limit_2030
                // subgroup
                // subgroup_id
                
            } rows: {
                ForEach(eventModelFilter.filteredEvents) { event in
                    TableRow(event)
//                        .contextMenu {
//                            Button("Edit") {
//                                // put here some code
//                            }
//                        }
                }
            }
            .onAppear {
                eventModelFilter.filteredEvents = eventModel.events
            }
            
            .contextMenu(forSelectionType: Event.ID.self) { eventIDs in
            } primaryAction: { eventIDs in
                if let id = eventIDs.first {
                    openWindow(id: "event-details", value: id)
                }
            }
            
            HStack {
                Button("Reload") {
//                    @MainActor
                    Task { await eventModel.reload() }
//                        .receive(on: DispatchQueue.main)}
                        
//                        .result { print($0) }
//                    eventModelFilter.reset()
                }
                .keyboardShortcut("r", modifiers: [.command])
                
                Button("Search") {
                    openWindow(id: "event-search")
                }
                .keyboardShortcut("f", modifiers: [.command])
                
                Spacer()
                
                Button("Close") {
                    dismiss()
                    NSApplication.shared.terminate(nil)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    
    // plan
    func planColumnHeader() -> Text {
        Text("План")
            .bold()
            .foregroundStyle(.blue)
    }
    
    // city
    func cityColumnHeader() -> Text {
        Text("Город")
            .bold()
            .foregroundStyle(.blue)
    }
    func cityColumnContext(for event: Event) -> Text {
        Text("\(event.city ?? "")")
    }
    
    //event
    func eventColumnHeader() -> Text {
        Text("Мероприятие")
            .bold()
            .foregroundStyle(.blue)
    }
    func eventColumnContext(for event: Event) -> Text {
        Text("\(event.event)")
    }
    
    // contract
    func contractColumnHeader() -> Text {
        Text("Договор/контракт")
            .bold()
            .foregroundStyle(.blue)
    }
    
    // senior
    func seniorColumnHeader() -> Text {
        Text("Ответственный\nисполнитель")
            .bold()
            .foregroundStyle(.blue)
    }
}


// MARK: - Preview

#Preview {
    EventListView()
        .environmentObject(EventModel.example)
        .environmentObject(EventModelFilter.shared)
        .environmentObject(DealModel.example)
//        .environmentObject(HistoryModel.example)
        .environmentObject(PlanModel.example)
        .frame(width: 600, height: 800)
}
