//
//  WiiPlanDataApp.swift
//  WiiPlanData
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
                await dealModel.fetch()
            }
        }
        
        WindowGroup(for: Event.ID.self) { $eventID in
            if let eventID {
                EventDetail(id: eventID)
                    .environmentObject(eventModel)
            }
        }
        
    } // body
    
    
    // Additional Views
    
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
