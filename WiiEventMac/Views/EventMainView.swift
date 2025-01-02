//
//  Created by Wiipuri Developer on 30.10.2024.
//


import SwiftUI
import WiiKit


struct EventMainView: View {
    @Environment(\.openWindow) private var openWindow
    
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var dealModel: DealModel

    @State private var selection = Set<Event.ID>()
    
    
    var filteredEvents: [Event] {
        eventModel.events
    }
    
    @State private var isPresentedEventDetailsView: Bool = false
    
    
    // MARK: - Body view
    
    var body: some View {
        VStack {
            Table(of: Event.self, selection: $selection) {
                
                // Мероприятие
                TableColumn(eventColumnHeader()) { event in
                    eventColumnContext(for: event)
                        .lineLimit(5)
                }
                
                // Номер договора
                TableColumn(contractColumnHeader()) { event in
                    if let deals = dealModel.findDeals(byEventID: event.id) {
                        if let deal = deals.first {
                            VStack(alignment: .leading, spacing: 5) {
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
                            }
                        }
                    }
                }
                
                // Дата заключения
                TableColumn(Text("Дата заключения договора").bold().foregroundStyle(.blue)) { event in
                    if let deals = dealModel.findDeals(byEventID: event.id) {
                        if let deal = deals.first {
                            VStack(alignment: .leading, spacing: 5) {
                                if deal.isPlanning {
                                    PlanningButton(isPlanning: .constant(true))
                                    Text(DateFormatter.planningMonth.string(from: deal.startingDate))
                                } else {
                                    Text(DateFormatter.longDateFormatter.string(from: deal.startingDate))
                                }
                            }
                        }
                    }
                }
                
                // Дата закрытия договора
                TableColumn(Text("Дата закрытия договора").bold().foregroundStyle(.blue)) { event in
                    if let endDate = event.endDate {
                        Text(/*DateFormatter.longDateFormatter.string(from: endDate)*/ endDate)
                    } else {
                        Text("")
                    }
                }
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
                    VStack(alignment: .leading) {
                        Group {
                            Text("\(event.contragent ?? "")")
                            Text("\(event.subcontractor ?? "")")
                        }
                        .padding(5)
                        .border(Color.primary, width: 1)
                    }
                }
                // city
                TableColumn(Text("Город").bold().foregroundStyle(.blue)) { event in
                    Text("\(event.city ?? "")")
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
                    openWindow(value: id)
                }
            }
            
            // Table
            
            HStack {
                Text("Filter")
                List {
                    Text("TEST")
                }
                .frame(height: 50)
                Spacer()
            }
            .padding()
        }
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
        Text("Номер договора")
            .bold()
            .foregroundStyle(.blue)
    }
}


// MARK: - Preview

#Preview {
    EventMainView()
        .environmentObject(EventModel.example)
        .environmentObject(DealModel.example)
}


// MARK: - Additional Views

