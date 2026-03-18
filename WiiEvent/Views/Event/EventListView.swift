import SwiftUI

struct EventListView: View {
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var dealModel: DealModel
    @EnvironmentObject var planModel: PlanModel
    @EnvironmentObject var eventModelFilter: EventModelFilter
    
    @State private var searchableText = ""
    @State private var showSearchSheet = false
    @State private var showCompletedOnly = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(eventModelFilter.filteredEvents) { event in
                    NavigationLink(destination: EventDetailsView(id: event.id)) {
                        EventRowView(for: event)
                    }
                }
            }
            .listStyle(.grouped)
            .listRowSpacing(0)
            .searchable(
                text: $searchableText,
                placement: .navigationBarDrawer,
                prompt: "Поиск по городу..."
            )
            .refreshable {
                eventModelFilter.filteredEvents = eventModel.events
            }
        }
        .onAppear {
            eventModelFilter.filteredEvents = eventModelFilter.filterEvents(eventModel.events)
        }
    }
}

#Preview {
    EventListView()
        .environmentObject(EventModel.example)
        .environmentObject(DealModel.example)
        .environmentObject(PlanModel.example)
        .environmentObject(EventModelFilter.shared)
}
