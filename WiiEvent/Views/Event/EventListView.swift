import SwiftUI

struct EventListView: View {
    @EnvironmentObject var eventModel: EventModel
//    @EnvironmentObject var dealModel: DealModel
    @EnvironmentObject var eventModelFilter: EventModelFilter
    
    @State private var searchableText = ""
    @State private var showSearchSheet = false
    // Filtered events
    @State private var showCompletedOnly = false

    // MARK: - BODY
    
    var body: some View {
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
//            .animation(.default, value: filteredEvents)
            .searchable(
                text: $searchableText,  
                placement: .navigationBarDrawer,
                prompt: "Поиск по городу..."
            )
        }
        .onAppear {
            eventModelFilter.filteredEvents = eventModel.events
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
//                    FiltersView()
                }
            }
        } // toolbar
            
    } // body
}


#Preview {
    EventListView()
        .environmentObject(EventModel.example)
        .environmentObject(DealModel.example)
        .environmentObject(EventModelFilter.shared)
}
