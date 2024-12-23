//
//  EventTableView.swift
//  WiiEventMac
//
//  Created by Wiipuri Developer on 30.10.2024.
//


import SwiftUI


struct EventHome: View {
    @Environment(\.openWindow) private var openWindow
    
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var dealModel: DealModel
    
//    @State private var selection: Event.ID? = nil
    @State private var selection = Set<Event.ID>()
    
    var filteredEvents: [Event] {
        eventModel.events
    }
    
    @State private var isPresentedEventDetailsView: Bool = false
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    // MARK: - Body view
    
    var body: some View {
        VStack {
            Table(of: Event.self, selection: $selection) {
                
                // event
                TableColumn(eventHeader().bold().foregroundStyle(.blue)) { event in
                    eventColumn(for: event)
                        .lineLimit(5)
                }
                // contract
                TableColumn(Text("Номер договора/контракта/доп.соглашения\nдата заключения").bold().foregroundStyle(.blue)) { event in
                    if let deals = dealModel.findDeals(byEventID: event.id) {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(deals) { deal in
                                HStack {
                                    Text(deal.typeAbbr)
                                    Text("№ ")
                                    Text(deal.deal ?? "")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary)
                                    Text(" от ")
                                    Text(dateFormatter.string(from: deal.startDate))
                                }
                                .padding(5)
                                .border(Color.primary, width: 1)
                            }
                        }
                    }
                }
                .width(ideal: 50)
                // end_date
                TableColumn(Text("Дата окончания\nмероприятия").bold().foregroundStyle(.blue)) { event in
                    Text("\(event.endDate ?? "")")
                }
                // price
                TableColumn(Text("Стоимость мероприятия, ₽ (руб)").bold().foregroundStyle(.blue)) { event in
                    Group {
                        Text("\(event.price ?? 0.0)") +
                        Text(" ")                     +
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
                        .contextMenu {
                            Button("Edit") {
                                // put here some code
                            }
                        }
                }
            }
            
            .contextMenu(forSelectionType: Event.ID.self) { events in
            } primaryAction: { events in
                if events.count == 1 {
                    openWindow(value: events.first)
                }
            }
            
//            .sheet(isPresented: $isPresentedEventDetailsView) {
//                NavigationStack {
//                    EventDetail(id: 24)
//                }
//            }
            
//            .inspector(isPresented: $isPresentedEventDetailsView) {
//                EventDetail(id: 24)
//            }
            
//            .onAppear {
//                selection = filteredEvents.first?.id
//            }
            
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
    func eventHeader() -> Text {
        Text("Наименование мероприятия")
            .bold()
            .foregroundStyle(.primary)
    }
    
    func eventColumn(for event: Event) -> Text {
        Text("\(event.event)")
    }
}


// MARK: - Preview

#Preview {
    EventHome()
        .environmentObject(EventModel.example)
        .environmentObject(DealModel.example)
}
