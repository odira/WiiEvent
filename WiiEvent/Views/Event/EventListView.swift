import SwiftUI

struct EventListView: View {
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var dealModel: DealModel
    @EnvironmentObject var planModel: PlanModel
    @EnvironmentObject var eventModelFilter: EventModelFilter
    
    @State private var searchableText = ""
    @State private var showSearchSheet = false
    // Filtered events
    @State private var showCompletedOnly = false

    var body: some View {
        VStack {
            NavigationStack {
                List {
                    ForEach(eventModelFilter.filteredEvents) { event in
                        NavigationLink(destination: EventDetails(id: event.id)) {
                            EventRow(event: event)
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

                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showSearchSheet.toggle()
                        }, label: {
                            Label("Search", systemImage: "magnifyingglass")
                                .labelStyle(.iconOnly)
                        })
                        .sheet(isPresented: $showSearchSheet) {
                            EventModelFilterView()
                        }
                    }
                }
            }
            .onAppear {
                eventModelFilter.filteredEvents = eventModel.events
            }
        }
            
    } // body
}


#Preview {
    EventListView()
        .environmentObject(EventModel.example)
        .environmentObject(DealModel.example)
        .environmentObject(PlanModel.example)
        .environmentObject(EventModelFilter.shared)
}
