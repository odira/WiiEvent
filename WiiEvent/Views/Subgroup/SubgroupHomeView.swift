import SwiftUI

struct SubgroupHomeView: View {
//    @EnvironmentObject var subgroupModel: SubgroupModel
    
    @State private var subgroups = [Subgroup]()
    
    @State private var showSearchSheet = false

    // Filtered events
    @State private var showCompletedOnly = false
    @State private var optionalStatus = OptionalStatus.all
    @State private var showPlan = ""
    @State private var showValidOnly = true
    
//    var filteredEvents: [Event] {
//        eventModel.events
//        
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
//    }
    
    let columns: [GridItem] =
    if UIDevice.current.userInterfaceIdiom == .pad {[
        GridItem(.adaptive(minimum: 200))
    ]}
    else if UIDevice.current.userInterfaceIdiom == .phone {[
        GridItem(.flexible(maximum: .infinity)),
        GridItem(.flexible(maximum: .infinity)),
        GridItem(.flexible(maximum: .infinity))
    ]}
    else {[ // macOS
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]}
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(subgroups) { subgroup in
                    NavigationLink {
                        SubgroupEventListView(subgroupId: subgroup.id)
                    } label: {
                        SubgroupItemView(subgroup: subgroup.subgroup)
                    }
                }
            }
            //                List(subgroupModel.subgroups) { subgroup in
            //                    NavigationLink(destination: SubgroupEventListView(subgroupId: subgroup.id)) {
            //                        SubgroupItemView(subgroup: subgroup.subgroup)                    }
            //                }
        }
        .padding()
        //            .navigationTitle("Группы мероприятий")
        
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
        
        .task {
            do {
                let subgroupModel = SubgroupModel()
                subgroups = try subgroupModel.subgroups
            } catch {
                subgroups = [Subgroup.example]
            }
        }
        
    } // body
}

#Preview {
    SubgroupHomeView()
//        .environmentObject(SubgroupModel.example)
}
