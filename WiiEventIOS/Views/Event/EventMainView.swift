import SwiftUI

struct EventMainView: View {
    @EnvironmentObject var eventModel: EventModel
    
    @State private var searchableText = ""
    @State private var showSearchSheet = false

    // Filtered events
    @State private var showCompletedOnly = false
    @State private var optionalStatus = OptionalStatus.all
    @State private var showPlan = ""
    @State private var showValidOnly = true
    
    
    // MARK: - FILTERING
    
    var filteredEvents: [Event] {
        eventModel.events
        
            .filter { event in
                (!showValidOnly || !event.isCompleted)
            }
        
            .filter { event in
                if !searchableText.isEmpty {
                    return event.city!.contains( searchableText )
                } else {
                    return true
                }
            }
        
            .filter { event in
                if optionalStatus == OptionalStatus.option {
                    return event.isOptional == true
                } else if optionalStatus == OptionalStatus.main {
                    return event.isOptional == false
                } else {
                    return true
                }
            }
            
            .filter { event in
                (!showValidOnly || event.valid)
            }
        
    }
    
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $showValidOnly) {
                    Text("Только действительные")
                }
                
                ForEach(filteredEvents) { event in
                    NavigationLink(destination: EventDetail(id: event.id)) {
                        EventRow(event: event)
                    }
                }
            }
            .listStyle(.grouped)
            .listRowSpacing(0)
            .animation(.default, value: filteredEvents)
            .searchable(
                text: $searchableText,
                placement: .navigationBarDrawer,
                prompt: "Поиск по городу..."
            )
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
                    FiltersView()
                }
            }
        } // .toolbar
            
    } // body
}

#Preview {
    EventMainView()
        .environmentObject(EventModel.example)
}
