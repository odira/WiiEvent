//
//  Created by Vladimir Ilin on 11.11.2023.
//

import SwiftUI

@main
struct WiiEventApp: App {
    @StateObject var eventModel = EventModel()
    @StateObject var historyModel = HistoryModel()
    @StateObject var dealModel = DealModel()
    @StateObject var planModel = PlanModel()
    @StateObject var infoModel = InfoModel()
    @StateObject var eventModelFilter = EventModelFilter()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if eventModel.isFetching {
                    SplashView()
                } else {
                     ContentView()
                        .environmentObject(eventModel)
                        .environmentObject(historyModel)
                        .environmentObject(dealModel)
                        .environmentObject(planModel)
                        .environmentObject(infoModel)
                        .environmentObject(eventModelFilter)
                }
            }
            .task {
                await eventModel.fetch()
                await historyModel.fetch()
                await dealModel.fetch()
                await planModel.fetch()
                await infoModel.fetch()
            }
        }
        
//        #if os(macOS)
//        
//            // EventDetail view (for macOS)
//            WindowGroup(id: "event-details", for: Event.ID.self) { $eventID in
//                if let eventID {
//                    EventDetailsView(id: eventID)
//                        .environmentObject(eventModel)
//                        .environmentObject(historyModel)
//                }
//            }
//            .defaultSize(CGSize(width: 600, height: 800))
//            .defaultPosition(.center)
//            
//            // HistoryDetail view (for macOS)
//            WindowGroup(id: "event-history-details", for: Event.self) { $event in
//                if let event {
//                    HistoryListView(for: event)
//                        .environmentObject(eventModel)
//                        .environmentObject(historyModel)
//                }
//            }
//            .defaultSize(CGSize(width: 600, height: 800))
//            .defaultPosition(.center)
//            
//            WindowGroup(id: "history-add", for: Event.ID.self) { $eventID in
//                if let eventID {
//                    HistoryAddView(eventId: eventID)
//                        .environmentObject(eventModel)
//                        .environmentObject(historyModel)
//                }
//            }
//            .defaultSize(CGSize(width: 600, height: 800))
//            .defaultPosition(.center)
//            
//            WindowGroup(id: "history-edit", for: History.self) { $history in
//                if let history {
//                    HistoryEditView(history: history)
//                        .environmentObject(historyModel)
//                }
//            }
//            .defaultSize(CGSize(width: 600, height: 800))
//            .defaultPosition(.center)
//            
//            WindowGroup(id: "event-search") {
//                EventModelFilterView()
//                    .environmentObject(eventModel)
//                    .environmentObject(eventModelFilter)
//                    .environmentObject(planModel)
//                    .environmentObject(dealModel)
//            }
//            .defaultPosition(.center)
//        
//            // InfoDetail view (for macOS)
//            WindowGroup(id: "event-info", for: Event.self) { $event in
//                if let event {
//                    InfoListView(for: event)
//                        .environmentObject(eventModel)
//                        .environmentObject(infoModel)
//                }
//            }
//            .defaultSize(CGSize(width: 600, height: 800))
//            .defaultPosition(.center)
//        
//            WindowGroup(id: "info-add", for: Event.ID.self) { $eventID in
//                if let eventID {
//                    InfoAddView(eventId: eventID)
////                        .environmentObject(eventModel)
//                        .environmentObject(infoModel)
//                }
//            }
//            .defaultSize(CGSize(width: 600, height: 800))
//            .defaultPosition(.center)
//        
//            WindowGroup(id: "info-edit", for: Info.self) { $info in
//                if let info {
//                    InfoEditView(info: info)
//                        .environmentObject(infoModel)
//                }
//            }
//            .defaultSize(CGSize(width: 600, height: 800))
//            .defaultPosition(.center)
//        
//        #endif
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
