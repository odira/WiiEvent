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
    
    var body: some Scene {
        
        // Splash & ContentView
        WindowGroup {
            ZStack {
                if eventModel.isFetching {
                    splashView
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
        
        // modal EventDetailView (for macOS)
        #if os(macOS)
        WindowGroup(for: Event.ID.self) { $eventID in
            if eventID != nil {
                EventDetail(id: eventID!)
                    .environmentObject(eventModel)
            }
        }
        #endif
    }
    
    // SPLASH View - show splash view at startup of the App
    var splashView: some View {
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
