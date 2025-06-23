import SwiftUI

struct EventDetails: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var historyModel: HistoryModel
    
    @State private var isPresentedJustificationSheet: Bool = false
    @State private var isPresentedDescriptionSheet: Bool = false
    @State private var isPresentedHistorySheet: Bool = false
    @State private var isPresentedMenu: Bool = false
    
    let id: Int

    // MARK: - body
    
    var body: some View {
        NavigationStack {
            
            if let event = eventModel.findEventById(id) {
                VStack {
                    Form {
                        VStack(alignment: .center) {
                            HStack(alignment: .center) {
                                Spacer()
                                CircleImage(image: event.image)
                                Spacer()
                            }
                            
                            Text(event.event)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            HStack {
                                Button("Обоснование") {
                                    isPresentedJustificationSheet.toggle()
                                }
                                .sheet(isPresented: $isPresentedJustificationSheet) {
                                    JustificationView(for: event.justification)
                                        .presentationDetents([.large])
                                        .presentationDragIndicator(.visible)
                                }
                                
                                Button("Описание") {
                                    isPresentedDescriptionSheet.toggle()
                                }
                                .sheet(isPresented: $isPresentedDescriptionSheet) {
                                    DescriptionView(for: event.description)
                                        .presentationDetents([.large])
                                        .presentationDragIndicator(.visible)
                                }
                                
                                Button("Исполнение") {
                                    isPresentedHistorySheet.toggle()
                                    
                                    #if os(macOS)
                                    openWindow(id: "event-history-details", value: id)
                                    #endif
                                }
                                #if os(iOS)
                                .sheet(isPresented: $isPresentedHistorySheet) {
                                    #if os(macOS)
                                    HistoryDetailView(eventId: id)
                                        .presentationDetents([.large])
                                        .presentationDragIndicator(.visible)
                                    #endif
                                }
                                #endif
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .listRowBackground(Color.clear)
                        
                        Section("Реквизиты договора/контракта") {
                            //                        LabeledContent("Номер", value: event.contract ?? "не заключен")
                            LabeledContent("Дата заключения", value: "N/A")
                            LabeledContent("Дата окончания", value: event.endDate ?? "")
                        }
                        
                        Section("Исполнение договора") {
                            LabeledContent("Год реализации", value: event.years ?? "")
                            LabeledContent("Ответственный исполнитель", value: event.senior ?? "")
                            LabeledContent("Номер позиции в Плане закупок", value: event.numberPZ ?? 0, format: .number)
                        }
                        
                        Section("Стоимость мероприятия") {
                            LabeledContent("Общая стоимость (руб.)", value: event.price ?? 0, format: .number)
                            NavigationLink(destination: PriceView(event: event)) {
                                Text("Стоимость по годам")
                            }
                        }
                        
                        Section("Орган ОВД") {
                            LabeledContent("Орган ОВД", value: event.unit ?? "")
                            LabeledContent("Город", value: event.city ?? "")
                        }
                        
                        Section("Оборудование") {
                            LabeledContent("Оборудование", value: event.equipment ?? "")
                            LabeledContent("Вид работ (наименование этапа)", value: event.phase ?? "")
                        }
                        
                        Section("Подрядчик") {
                            LabeledContent("Контрагент", value: event.contragent ?? "")
                            LabeledContent("Субподрядчик", value: event.subcontractor ?? "")
                        }
                    } // Form
                    .formStyle(.grouped)
                    
                }
                .font(.callout)
                
                // Toolbar
//                #if os(iOS)
//                .toolbar {
//                    ToolbarItemGroup {
//                        Button  {
//                            isPresentedMenu.toggle()
//                        } label: {
//                            HStack {
//                                Image(systemName: "list.bullet.circle")
//                                Text("Menu")
//                            }
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .controlSize(.regular)
//                    }
//                } // .toolbar
//                #endif
                
                #if os(macOS)
                HStack {
                    Spacer()
                    Button("Done") {
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                #endif
                
            }
        } // NavigationStack
        
//        // ОБОСНОВАНИЕ
//        .fullScreenCover(isPresented: $isPresentedJustificationSheet) {
//            NavigationStack {
//                VStack {
//                    Text("Обоснование выполнения мероприятия")
//                        .font(.title)
//                        .multilineTextAlignment(.center)
//                        .bold()
//                    Text(event.justification ?? "")
//                        .font(.subheadline)
//                    Spacer()
//                }
//                .toolbar {
//                    ToolbarItem(placement: .destructiveAction) {
//                        Button("Close") {
//                            isPresentedJustificationSheet.toggle()
//                        }
//                    }
//                }
//            }
//            .presentationSizing(.page)
//        }
        
        #if os(iOS)
        // ИСПОЛНЕНИЕ
        .fullScreenCover(isPresented: $isPresentedHistorySheet) {
            #if os(macOS)
            HistoryDetailView(eventId: event.id)
                .presentationSizing(.page)
            #endif
        }
        #endif
        
//        #if os(iOS)
        // MENU
        .confirmationDialog("Menu", isPresented: $isPresentedMenu, titleVisibility: .hidden) {
//        .sheet(isPresented: $isPresentedMenu) {
            VStack {
                Button("Исполнение") {
                    isPresentedHistorySheet.toggle()
                }
                .frame(maxWidth: .infinity)
                Button("Календарный план") {
                    
                }
                .frame(maxWidth: .infinity)
//                Button("Close", role: .cancel) { }
            }
            .buttonStyle(.borderedProminent)
        }
//        #endif
        
    } // body
    
}

#Preview {
    EventDetails(id: Event.example.id)
        .frame(width: 600, height: 800)
        .environmentObject(EventModel.example )
        .environmentObject(HistoryModel.example)
}
