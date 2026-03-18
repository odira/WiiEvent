import SwiftUI

struct EventDetailsView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var eventModel: EventModel
    @EnvironmentObject var historyModel: HistoryModel

    @State private var isPresentedDescriptionSheet: Bool = false
    @State private var isPresentedJustificationSheet: Bool = false
    @State private var isPresentedHistorySheet: Bool = false
    @State private var isPresentedInfoSheet: Bool = false
    @State private var isPresentedMenu: Bool = false
    
//    @State private var path: [String] = []
    
    let id: Int

    // MARK: - body
    
    var body: some View {
        VStack {
            if let event = eventModel.findEventById(id) {
                VStack {
                    Form {
                        ZStack {
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
                            }
                            
                            HStack {
                                Spacer()
                                VStack(alignment: .center) {
                                    Button("Описание") {
                                        isPresentedDescriptionSheet.toggle()
                                    }
                                    .sheet(isPresented: $isPresentedDescriptionSheet) {
                                        DescriptionView(for: event.description)
                                            .presentationDetents([.large])
                                            .presentationDragIndicator(.visible)
                                    }
                                    
                                    Button("Обоснование") {
                                        isPresentedJustificationSheet.toggle()
                                    }
                                    .sheet(isPresented: $isPresentedJustificationSheet) {
                                        JustificationView(for: event.justification)
                                            .presentationDetents([.large])
                                            .presentationDragIndicator(.visible)
                                    }

                                    Button("Исполнение") {
                                        isPresentedHistorySheet.toggle()
                                        #if os(macOS)
                                        openWindow(id: "event-history-details", value: id)
                                        #endif
                                    }
                                    .sheet(isPresented: $isPresentedHistorySheet) {
                                        HistoryListView(for: event)
                                            .presentationDetents([.large])
                                            .presentationDragIndicator(.visible)
                                    }

                                    Button("Справка") {
                                        isPresentedInfoSheet.toggle()
                                        #if os(macOS)
                                        openWindow(id: "event-info", value: id)
                                        #endif
                                    }
                                    .sheet(isPresented: $isPresentedInfoSheet) {
                                        InfoListView(for: event)
                                            .presentationDetents([.large])
                                            .presentationDragIndicator(.visible)
                                    }
                                    
                                    Spacer()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            
                        }
                        
                        Section("Реквизиты договора/контракта") {
                            LabeledContent("Дата заключения", value: "N/A")
                            LabeledContent("Дата окончания", value: event.endDate ?? "")
                        }
                        
                        Section("Исполнение договора") {
                            LabeledContent("Год реализации", value: event.years ?? "")
                            LabeledContent("Ответственный исполнитель", value: event.senior ?? "")
                        }
                        
                        Section("Стоимость мероприятия") {
                            LabeledContent("Общая стоимость (руб.)", value: event.limitTotal ?? 0, format: .number)
                            NavigationLink(destination: EventLimitView(event: event)) {
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
        }
    }
}

#Preview {
    EventDetailsView(id: Event.example.id)
        .frame(width: 600, height: 800)
        .environmentObject(EventModel.example )
        .environmentObject(HistoryModel.example)
}

struct ButtonBlockView: View {
    var body: some View {
        Text("Hello, World!")
    }
}
