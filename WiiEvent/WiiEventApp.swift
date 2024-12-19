//
//  WiiPlanDataApp.swift
//  WiiPlanData
//
//  Created by Vladimir Ilin on 11.11.2023.
//

import SwiftUI


@main
struct WiiEventApp: App {

    // MARK: - Models initialization
    @StateObject var eventModel = EventModel()
    @StateObject var historyModel = HistoryModel()
    @StateObject var dealModel = DealModel()
    
    // MARK: - Filters initialization
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
        
        WindowGroup("Event Details", for: Event.self) { event in //Swift.Optional<Swift.Int>.self) { $event in
//            EventDetail(id: event.id!)
//                .environmentObject(eventModel)
        }
        
    } // body
    
    
    // MARK: - Additional Views
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
