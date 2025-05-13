import SwiftUI


struct ContentView: View {
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var dealModel: DealModel
    
    enum TabValue {
        case list
        case category
        case group
    }
    
    @State private var tabArray = ["Список", "Категории", "Группы"]
    @State private var selectedTab: TabValue = .list
    
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            Tab(tabArray[0], systemImage: "list.bullet", value: .list) {
                EventListView()
            }
            Tab(tabArray[1], systemImage: "star", value: .category) {
                #if os(iOS)
//                CategoryHome()
                Text("TEST")
                #elseif os(macOS)
                Text("TEST")
                #endif
            }
            Tab(tabArray[2], systemImage: "rectangle.3.group.fill", value: .group) {
                #if os(iOS)
//                SubgroupHomeView()
                Text("TEST")
                #elseif os(macOS)
                Text("TEST")
                #endif  
            }
            
        } // TabView
    } // body
}

#Preview {
    ContentView()
        .environmentObject(EventModel.example)
        .environmentObject(DealModel.example)
}
