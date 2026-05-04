//
//  InfoList.swift
//  WiiEvent
//
//  Created by Vladimir Ilin on 28.08.2025.
//

import SwiftUI

struct InfoListView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var infoModel: InfoModel
    
    @Namespace private var namespace
    
    @State private var isPresentingAddSheet: Bool = false
    @State private var isPresentingEditSheet: Bool = false

    @State private var isFetching = true
    
    private var infos: [Info]? {
        if let infos = infoModel.findInfos(byEventID: eventID) {
            return infos
        }
        return nil
    }
    
    @State private var currentIndex = -1
    
    private let eventID: Int
    
    init(for event: Event) {
        self.eventID = event.id
    }
    
    // MARK: - body

    var body: some View {
        NavigationStack {
            ZStack {
                if infoModel.isFetching {
                    ProgressView("Fetching...")
                } else {
                    
                    VStack {
                        if infos != nil {
                            
                            ScrollViewReader { value in
                                ZStack {
                                    HStack {
                                        Button(action: {
                                            if currentIndex == -1 {
                                                currentIndex = infos!.count - 1
                                            }
                                            prevInfo()
                                            value.scrollTo(currentIndex)
                                        }, label: {
                                            Label("Назад", systemImage: "arrow.left.square.fill")
                                        })
                                        
                                        Button(action: {
                                            if currentIndex == -1 {
                                                currentIndex = infos!.count
                                            }
                                            nextInfo()
                                            value.scrollTo(currentIndex)
                                        }, label: {
                                            Label("Вперед", systemImage: "arrow.right.square.fill")
                                        })
                                    }
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack(spacing: 0) {
                                            ForEach(Array(zip(infos!.indices, infos!)), id: \.0) { index, info in
                                                InfoDetailsView(for: info)
                                                    .containerRelativeFrame(.horizontal)
                                                    .id(index)
                                            }
                                        }
                                        .scrollTargetLayout()
                                    }
                                    .scrollIndicators(.hidden)
                                    .scrollTargetBehavior(.paging)
                                    .defaultScrollAnchor(.trailing)
                                    .toolbar {
                                        ToolbarItem(placement: .confirmationAction) {
                                            Button("Add") {
                                                isPresentingAddSheet.toggle()
                                                Task {
                                                    await infoModel.fetch()
                                                }
                                            }
                                            .sheet(isPresented: $isPresentingAddSheet) {
                                                InfoAddView(eventId: eventID)
                                                    .environmentObject(infoModel)
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            Text("**Справочная информация отсутствует**")
                                .lineSpacing(8)
                                .frame(minHeight: 180)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .fixedSize(horizontal: false, vertical: false)
                                .textEditorStyle(.plain)
                                .background(.background)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .toolbar {
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("Add") {
                                            isPresentingAddSheet.toggle()
                                            Task {
                                                await infoModel.fetch()
                                            }
                                        }
                                        .sheet(isPresented: $isPresentingAddSheet) {
                                            InfoAddView(eventId: eventID)
                                                .environmentObject(infoModel)
                                        }
                                    }
                                }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.yellow.opacity(0.1))
                }
                
            }
        }
        .task {
            await infoModel.fetch()
        }
    }
    
    private func nextInfo() {
        if infos != nil {
            if currentIndex < infos!.count - 1 {
                currentIndex += 1
            }
        }
    }
    
    private func prevInfo() {
        if infos != nil {
            if currentIndex > 0 {
                currentIndex -= 1
            }
        }
    }
}

#Preview {
    InfoListView(for: Event.example)
        .environmentObject(InfoModel.example)
    
        #if os(macOS)
        .frame(width: 600, height: 800)
        #endif
}
