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
    @EnvironmentObject var historyModel: HistoryModel

    @State private var selection = Set<Event.ID>()
    @State private var isPresentedEventDetailsView: Bool = false
    
//    var filteredEvents: [Event] {
//        eventModel.events
//    }
    
    // MARK: - FILTERING
    
    @State private var cityFilter: String = ""
    
    var filteredEvents: [Event] {
        var result = eventModel.events
        
        // city
        if !cityFilter.isEmpty {
            result = result.filter { event in
                event.city!.lowercased().contains(cityFilter.lowercased())
            }
        }
        
//        result = result.filter { event in
//            (!showValidOnly || !event.isCompleted && !event.isOptional)
//        }
//        
//        result = result.filter { event in
//            //                if optionalStatus == OptionalStatus.option {
//            //                    return event.isOptional == true
//            //                } else if optionalStatus == OptionalStatus.main {
//            //                    return event.isOptional == false
//            //                } else {
//            //                    return true
//            //                }
//            (!showOptionalOnly || event.isOptional && !showValidOnly)
//        }
//        
//        result = result.filter { event in
//            if !searchableText.isEmpty {
//                return event.city!.contains( searchableText )
//            } else {
//                return true
//            }
//        }
        
        return result
    }
    
    
    // MARK: - Body view
    var body: some View {
        VStack {
            Table(of: Event.self, selection: $selection) {
                
                // City
                TableColumn(cityColumnHeader()) { event in
                    cityColumnContext(for: event)
                        .padding(15)
                }
                
                // Event
                TableColumn(eventColumnHeader()) { event in
                    eventColumnContext(for: event)
                        .lineLimit(5)
                        .padding(15)
                }
                
                // _contract number_ & _date of conclusion_
                TableColumn(contractColumnHeader()) { event in
                    if let deals = dealModel.findDeals(byEventID: event.id) {
                        
                        if let deal = deals.first {
                            VStack(alignment: .leading, spacing: 5) {
                                
                                DealStatusTransparant(for: deal)
                                
                                // Deal is planning & not concluded
                                if deal.isPlanning {
                                    
//                                    PlanningButton(isPlanning: .constant(true))
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
                        Text((event.price ?? 0.0), format: .number) +
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
                
                // equipment
                // phase
                // years
                // senior
                // end_morder
                // event_description
                // is_completed
                // is_optional
                // justification
                // note
                // fp
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
                ForEach(filteredEvents) { event in
                    TableRow(event)
//                        .contextMenu {
//                            Button("Edit") {
//                                // put here some code
//                            }
//                        }
                }
            }
            
            .contextMenu(forSelectionType: Event.ID.self) { eventIDs in
            } primaryAction: { eventIDs in
                if let id = eventIDs.first {
                    openWindow(id: "event-details", value: id)
                }
            }
            
            // Table
            
            HStack {
                Label("Search", systemImage: "magnifyingglass")
                TextField("Search", text: $cityFilter)
                Button("Clear") {
                    cityFilter = ""
                }
            }
            .padding()
            
            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                    NSApplication.shared.terminate(nil)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    
// ----------------------------------------------------------------------------------------------------
    
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
}


// MARK: - Preview

#Preview {
    EventListView()
        .environmentObject(EventModel.example)
        .environmentObject(DealModel.example)
        .environmentObject(HistoryModel.example)
        .frame(width: 600, height: 800)
}


// MARK: - Additional Views

