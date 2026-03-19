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
            ZStack {
                if historyModel.isFetching {
                    ProgressView("Fetching...")
                } else {
                    
                    VStack {
                        List(histories) { history in
                            HistoryListRowView(history: history)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init())
                                #if os(iOS)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive, action: {
                                        Task {
                                            await historyModel.sqlDELETE(historyId: history.id)
                                            await historyModel.fetch()
                                        }
                                    }, label: {
                                        Label("Delete", systemImage: "trash")
                                    })
                                    
                                    Button(action: {
                                        selectedHistory = history
                                        isPresentingEditSheet.toggle()
                                    }, label: {
                                        Label("Edit", systemImage: "square.and.pencil")
                                    })
                                    .tint(.orange)
                                }
                                #endif
                        }
//                        .scrollContentBackground(.hidden)
//                        .background(Color.orange)
                        .defaultScrollAnchor(.top)
                        
                        #if os(iOS)
                        .navigationBarTitle("Исполнение", displayMode: .inline)
                        
                        .sheet(item: $selectedHistory) { history in
//                            HistoryEditSheet(history: history)
//                                .environmentObject(historyModel)
                        }
                        
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Add") {
                                    isPresentingAddSheet.toggle()
                                    Task {
                                        await historyModel.fetch()
                                    }
                                }
                                .sheet(isPresented: $isPresentingAddSheet) {
//                                    HistoryAddSheet(eventId: self.eventId)
//                                        .environmentObject(historyModel)
                                }
                            }
                            ToolbarItem(placement: .destructiveAction) {
                                Button("Close") {
                                    dismiss()
                                }
                            }
                        }
                        #endif
                        
                        #if os(macOS)
                        HStack {
                            Button("Add") {
                                openWindow(id: "history-add", value: eventId)
                            }
                            
                            Spacer()
                            
                            Button("Done") {
                                dismiss()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .background(Color.yellow.opacity(0.1))
                        #endif
                    }
                }
            }
        .task {
            await historyModel.fetch()
        }
        
    } // body
}

#Preview {
    HistoryListView(for: Event.example)
        .environmentObject(EventModel.example)
        .environmentObject(HistoryModel.example)
        #if os(macOS)
        .frame(width: 600, height: 800)
        #endif
}
