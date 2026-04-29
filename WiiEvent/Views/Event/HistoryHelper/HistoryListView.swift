import SwiftUI

struct HistoryListView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var historyModel: HistoryModel
    
    @Namespace private var namespace
    
    @State private var isPresentingAddSheet: Bool = false
    @State private var isPresentingEditSheet: Bool = false
    @State private var isFetching = true
    
    private var histories: [History] {
        if let histories = historyModel.findHistories(byEventId: eventId) {
            return histories
        }
        return []
    }

    // Selection
    @State var selectedHistory: History? = nil
    
    private let eventId: Int
    
    init(for event: Event) {
        self.eventId = event.id
    }
    
    // MARK: - body

    var body: some View {
        NavigationStack {
            ZStack {
                if historyModel.isFetching {
                    ProgressView("Fetching...")
                } else {
                    
                    VStack {
                        List(histories) { history in
                            HistoryListRowView(history: history)
                                .id(history.id)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init())
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive, action: {
                                        Task {
                                            await historyModel.sqlDELETE(historyId: history.id)
                                            await historyModel.fetch()
                                        }
                                    }, label: {
                                        Label("Delete", systemImage: "trash")
                                    })
                                    
                                    NavigationLink {
                                        HistoryEditView(history: history)
                                    } label: {
                                        Text("Edit")
                                    }
                                    .tint(.orange)

                                }
                        }
                        .navigationBarTitle("Исполнение по мероприятию", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                NavigationLink(destination: HistoryAddView(eventId: eventId)) {
                                    Text("Add")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }
            }
            .task {
                await historyModel.fetch()
            }
        }
    }
}

#Preview {
    HistoryListView(for: Event.example)
        .environmentObject(EventModel.example)
        .environmentObject(HistoryModel.example)
        #if os(macOS)
        .frame(width: 600, height: 800)
        #endif
}
