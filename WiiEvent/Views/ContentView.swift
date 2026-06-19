import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var eventModel: EventModel
    @EnvironmentObject private var eventModelFilter: EventModelFilter

    var body: some View {
        NavigationStack {
            TabView {
                Tab("Список", systemImage: "list.bullet") {
                    EventListView()
                }
                Tab("Категория", systemImage: "star") {
                    Text("Not developed")
                }
                Tab("Группа", systemImage: "rectangle.3.group.fill", role: .prominent) {
                    Text("Not developed")
                }
                Tab("Search", systemImage: "magnifyingglass", role: .prominent) {
                    EventModelFilterView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(EventModel())
        .environmentObject(EventModelFilter())
}
