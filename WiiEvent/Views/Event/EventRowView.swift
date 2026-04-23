import SwiftUI

struct EventRowView: View {
    @EnvironmentObject private var dealModel: DealModel
    @EnvironmentObject var planModel: PlanModel
    
    let event: Event
    
    init(for event: Event) {
        self.event = event
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                cityView()
                eventView()
                eventDealView()
                contragentView()
            }
            .padding()
        }
    }
    
    // city
    fileprivate func cityView() -> some View {
        HStack {
            event.image
                .resizable()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text("Аэронавигация Северо-Восточной Сибири")
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
                Text(event.city ?? "")
                    .lineLimit(3)
            }
            .font(.footnote)
            
            Spacer()
        }
    }
    
    // Event
    fileprivate func eventView() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    event.statusTransparant(for: event)
                    if let plan = planModel.findPlanByID(id: event.planId) {
                        plan.transparant(for: plan)
                    }
                    if event.isOption {
                        event.isOptionTransparant(for: event)
                    }
                }
                Text(event.event)
                    .bold()
                    .lineLimit(5)
                Spacer()
            }
            Spacer()
        }
    }
    
    // Deal
    fileprivate func eventDealView() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                /// Transparants Bar
                HStack {
                    event.dealStatusTransparant(event: event)
                    Spacer()
                }
                
                /// dealStatusID == 1 == Планируется
                if event.dealStatusID == 1 {
                    if let date = event.dealStartDate {
                        Text(DateFormatter.planningMonth.string(from: date))
                    }
                } else {
                    HStack {
                        if let deal = event.deal {
                            Text("\(event.dealTypeAbbrText) №")
                            Text(deal).bold()
                        }

                        Spacer()
                    }
                    
                    if let startDate = event.dealStartDate {
                        Text("от \(DateFormatter.longDateFormatter.string(from: startDate))")
                    }
                    
                    if let price = event.dealPrice {
                        Text("\((price), format: .number) руб.")
                    }
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
    }
    
    // contragent
    fileprivate func contragentView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                if let contragent = event.contragent {
                    Text(contragent)
                }
                if let subcontractor = event.subcontractor {
                    Text(subcontractor)
                }
                EmptyView()
            }
            
            Spacer()
        }
    }
    
//    fileprivate func seniorView() -> some View {
//        HStack {
//            VStack {
//                if let senior = event.senior {
//                    Text("\(senior)")
//                } else {
//                    EmptyView()
//                }
//            }
//            
//            Spacer()
//        }
//    }
}


// MARK: - Preview Section

#Preview("Light Theme", traits: .sizeThatFitsLayout) {
    Group {
        EventRowView(for: Event.example)
        EventRowView(for: Event.example)
        EventRowView(for: Event.example)
    }
    .preferredColorScheme(.light)
    .environmentObject(DealModel.example)
    .environmentObject(PlanModel.example)
}

#Preview("Dark Theme", traits: .sizeThatFitsLayout) {
    Group {
        EventRowView(for: Event.example)
        EventRowView(for: Event.example)
        EventRowView(for: Event.example)
    }
    .preferredColorScheme(.dark)
    .environmentObject(DealModel.example)
    .environmentObject(PlanModel.example)
}
