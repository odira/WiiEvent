//
//  Created by Vladimir Ilin on 11.11.2023.
//

import SwiftUI

@main
struct WiiEventApp: App {
    @StateObject var eventModel = EventModel()
    @StateObject var historyModel = HistoryModel()
    @StateObject var dealModel = DealModel()
    @StateObject var filters = Filters()
    
    // MARK: - body
    
    var body: some Scene {
        
        // SplashView & ContentView
        WindowGroup {
            ZStack {
                if eventModel.isFetching {
                    SplashView()
                } else {
                     ContentView()
                        .environmentObject(eventModel)
                        .environmentObject(historyModel)
                        .environmentObject(dealModel)
                        .environmentObject(filters)
                }
            }
            .task {
                await eventModel.fetch()
                await historyModel.fetch()
                await dealModel.fetch()
            }
        }
        .defaultSize(CGSize(width: 1200, height: 800))
        
        #if os(macOS)
        // EventDetail view (for macOS)
        WindowGroup(id: "event-details", for: Event.ID.self) { $eventID in
            if let eventID {
                EventDetails(id: eventID)
                    .environmentObject(eventModel)
                    .environmentObject(historyModel)
            }
        }
        .defaultSize(CGSize(width: 600, height: 800))
        .defaultPosition(.center)
        
        // HistoryDetail view (for macOS)
        WindowGroup(id: "event-history-details", for: Event.ID.self) { $eventID in
            if let eventID {
                HistoryList(eventId: eventID)
                    .environmentObject(eventModel)
                    .environmentObject(historyModel)
            }
        }
        .defaultSize(CGSize(width: 600, height: 800))
        .defaultPosition(.center)
        
        WindowGroup(id: "history-add", for: Event.ID.self) { $eventID in
            if let eventID {
                HistoryAddView(eventId: eventID)
                    .environmentObject(eventModel)
                    .environmentObject(historyModel)
            }
        }
        .defaultSize(CGSize(width: 600, height: 800))
        .defaultPosition(.center)
        
        WindowGroup(id: "history-edit", for: History.ID.self) { $id in
            if let id {
                HistoryEditSheet(history: id)
                    .environmentObject(eventModel)
                    .environmentObject(historyModel)
            }
        }
        .defaultSize(CGSize(width: 600, height: 800))
        .defaultPosition(.center)
        #endif
    }
}

// MARK: - Splash View

struct SplashView: View {
    var body: some View {
        VStack {
            Image(systemName: "memorychip")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.orange)
            ProgressView("Loading data from remote database...")
                .font(.headline).bold()
                .padding()
        }
    }
}
