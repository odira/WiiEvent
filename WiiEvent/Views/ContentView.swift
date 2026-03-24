import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var eventModel: EventModel
    @EnvironmentObject private var eventModelFilter: EventModelFilter

    var body: some View {
        TabView {
            Tab("Список", systemImage: "list.bullet") {
                EventListView()
            }
            Tab("Категория", systemImage: "star") {
                Text("Not developed")
            }
            Tab("Группа", systemImage: "rectangle.3.group.fill") {
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
        .environmentObject(EventModelFilter())
}
