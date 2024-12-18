import SwiftUI

struct EventDetail: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var eventModel: EventModel
    
    @State private var isPresentedHistorySheet: Bool = false
    @State private var isPresentedJustificationSheet: Bool = false
    @State private var isPresentedMenu: Bool = false

    private var event: Event {
        eventModel.findEventById(id: id)!
    }
    
    var id: Int = 100

    
    var body: some View {
        NavigationStack {
            VStack {
                
                Form {
                    VStack {
                        CircleImage(image: event.image)
                        
                        Text(event.event)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack {
                            if event.isCompleted {
                                CompletedButton(isCompleted: .constant(true))
                            }
                            if event.isOptional {
                                OptionalButton(isOptional: .constant(true))
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    Section("Договор") {
                        LabeledContent("Договор", value: event.contract ?? "не заключен")
                        LabeledContent("Заключен", value: "N/A")
                        LabeledContent("Дата окончания", value: event.endDate ?? "")
                        LabeledContent("Год реализации", value: event.years ?? "")
                        LabeledContent("Ответственный исполнитель", value: event.senior ?? "")
                        LabeledContent("Обоснование") {
                            JustificationView()
                        }
                    }
                    
                    Section("Стоимость мероприятия") {
                        LabeledContent("Общая стоимость (руб.)", value: event.price ?? 0, format: .number)
                        NavigationLink {
                            PriceView(event: event)
                        } label: {
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
                }
            }
            .font(.callout)
            
            .toolbar {
//                ToolbarItemGroup(placement: .bottomBar) {
                ToolbarItemGroup {
                        Button  {
                            isPresentedMenu.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "list.bullet.circle")
                                Text("Menu")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)
                }
            } // .toolbar

        } // NavigationStack
        
        
        // ОБОСНОВАНИЕ
        .fullScreenCover(isPresented: $isPresentedJustificationSheet) {
            NavigationStack {
                VStack {
                    Text("Обоснование выполнения мероприятия")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .bold()
                    Text(event.justification ?? "")
                        .font(.subheadline)
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Close") {
                            isPresentedJustificationSheet.toggle()
                        }
                    }
                }
            }
            .presentationSizing(.page)
        }
        
        // ИСПОЛНЕНИЕ
        .fullScreenCover(isPresented: $isPresentedHistorySheet) {
            HistoryDetailView(eventId: event.id)
                .presentationSizing(.page)
        }
        
        // MENU
        .confirmationDialog("Menu", isPresented: $isPresentedMenu, titleVisibility: .hidden) {
//        .sheet(isPresented: $isPresentedMenu) {
            VStack {
                Button("Обоснование") {
                    isPresentedJustificationSheet.toggle()
                }
                .frame(width: .infinity)
                Button("Описание") {
                    isPresentedJustificationSheet.toggle()
                }
                .frame(maxWidth: .infinity)
                Button("Исполнение") {
                    isPresentedHistorySheet.toggle()
                }
                .frame(maxWidth: .infinity)
                Button("Календарный план") {
                    
                }
                .frame(maxWidth: .infinity)
//                Button("Close", role: .cancel) { }
            }
            .frame(width: .infinity)
            .buttonStyle(.borderedProminent)
        }
        
        
    } // body
    
}


#Preview {
    EventDetail(id: Event.example.id)
        .environmentObject(EventModel.example )
}
