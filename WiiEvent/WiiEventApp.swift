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
        
        // EventDetail view (for macOS)
        WindowGroup(id: "event-detail", for: Event.ID.self) { $eventID in
            if let eventID {
                EventDetail(id: eventID)
//                    .frame(minWidth: 500, idealWidth: 1200, minHeight: 500, idealHeight: 1200)
                    .environmentObject(eventModel)
                    .environmentObject(historyModel)
            }
        }
        .defaultSize(CGSize(width: 800, height: 1200))
//        .windowResizability(.contentMinSize)
        .defaultPosition(.center)
    }
    
    // MARK: - Splash View
    
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
