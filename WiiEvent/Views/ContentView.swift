import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            Tab("Список", systemImage: "list.bullet") {
                EventListView()
            }
            Tab("Категория", systemImage: "star") {
                // CategoryHome()
                Text("Not developed")
            }
            Tab("Группа", systemImage: "rectangle.3.group.fill") {
                // SubgroupHomeView()
                Text("Not developed")
            }
            Tab {
                EventModelFilterView()
            } label: {
                Label("Find", systemImage: "magnifyingglass")
                    .labelStyle(.iconOnly)
            }
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(EventModel())
//        .environmentObject(HistoryModel())
//        .environmentObject(DealModel())
//        .environmentObject(PlanModel())
//        .environmentObject(InfoModel())
        .environmentObject(EventModelFilter())
}
