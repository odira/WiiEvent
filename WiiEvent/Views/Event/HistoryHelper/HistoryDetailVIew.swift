import SwiftUI


struct HistoryDetailView: View {
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

    @State var selectedHistory: History? = nil
    
    let eventId: Int
    
    // MARK: - body

    var body: some View {
        NavigationStack {
            
            ZStack {
                if historyModel.isFetching {
                    ProgressView("Fetching...")
                } else {
                    
                    List(histories) { history in
                        HistoryRow(history: history)
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
                    }
                    .listStyle(.plain)
                    .defaultScrollAnchor(.bottom)
                    #if os(iOS)
                    .navigationBarTitle("Исполнение", displayMode: .inline)
                    #endif
                    
                    .sheet(item: $selectedHistory) { history in
                        HistoryEditSheet(history: history)
                            .environmentObject(historyModel)
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
                                HistoryAddSheet(eventId: self.eventId)
                                    .environmentObject(historyModel)
                            }
                        }
                        ToolbarItem(placement: .destructiveAction) {
                            Button("Close") {
                                dismiss()
                            }
                        }
                    }
                } // List
                
            } // ZStack
            
        } // NavigationStack
        .task {
            await historyModel.fetch()
        }
        
    } // body
}

#Preview {
    HistoryDetailView(eventId: Event.example.id)
        .environmentObject(EventModel.example)
        .environmentObject(HistoryModel.example)
}

struct HistoryRow: View {
    
    let history: History
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    
    var body: some View {
       
        HStack(alignment: .top, spacing: 20) {
            
            Text(dateFormatter.string(from: history.date))
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.blue)
                .bold()
                .background(.clear)
            
            VStack(alignment: .leading) {
                Text(history.history)
                    .font(.system(.caption2, design: .monospaced))
                    .background(.clear)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: .infinity)
            
            Spacer()
        }
        
    }
}
