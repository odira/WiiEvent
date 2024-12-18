import SwiftUI

struct SubgroupEventListView: View {
    @EnvironmentObject var eventModel: EventModel
    
    let subgroupId: Int
    
    @State private var showSearchSheet = false

    // Filtered events
    @State private var showCompletedOnly = false
    @State private var optionalStatus = OptionalStatus.all
    @State private var showPlan = ""
    @State private var showValidOnly = true
    
    var filteredEvents: [Event] {
        eventModel.events
        
//            .filter { event in
//                if optionalStatus == OptionalStatus.option {
//                    return event.isOptional == true
//                } else if optionalStatus == OptionalStatus.main {
//                    return event.isOptional == false
//                } else {
//                    return true
//                }
//            }
//        
//            .filter { event in
//                (!showCompletedOnly || event.isCompleted)
//            }
//            
//            .filter { event in
//                (!showValidOnly || event.valid)
//            }
        
            .filter { event in
                return event.subgroupId == subgroupId
            }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    
                    Toggle(isOn: $showValidOnly) {
                        Text("Только действительные")
                    }
                    
                    ForEach(filteredEvents) { event in
                        NavigationLink {
                            EventDetail(id: event.id)
                        } label: {
                            EventRow(event: event)
                        }
                    }
                    
                }
                .animation(.default, value: filteredEvents)
                .listStyle(.grouped)
                
            }
            .navigationTitle("Список мероприятий")
            
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
            }
            
        }
    }
}

#Preview {
    SubgroupEventListView(subgroupId: 1)
        .environmentObject(EventModel.example)
}
