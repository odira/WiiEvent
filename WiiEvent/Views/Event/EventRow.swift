import SwiftUI

struct EventRow: View {
    @EnvironmentObject private var dealModel: DealModel
    
    let event: Event
    
    var body: some View {
        HStack {
            cityView()
            eventView()
            dealView()
            priceView()
            contragentView()
            seniorView()
        }
        .padding()
    }
    
    // city
    fileprivate func cityView() -> some View {
        HStack {
            event.image
                .resizable()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(event.city ?? "")
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
            
//            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // event
    fileprivate func eventView() -> some View {
        VStack(alignment: .leading) {
            Text(event.event)
                .font(.footnote)
                .bold()
                .lineLimit(3)
        }
    }
    
    // deal
    fileprivate func dealView() -> some View {
            VStack(alignment: .leading) {
                if let deal = dealModel.findDeals(byEventID: event.id)?.first {
                    HStack {
                        DealStatusTransparant(for: deal)
                        Spacer()
                    }
                    
                    // Deal is planning & not concluded
                    if deal.isPlanning {
                        Text(DateFormatter.planningMonth.string(from: deal.startingDate))
                    
                    // Deal is concluded
                    } else {
                        HStack {
                            Text(deal.typeAbbr)
                            Text("№ ")
                            Text(deal.deal ?? "")
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
//                            if deals.count > 1 {
//                                Image(systemName: "list.bullet.circle")
//                                    .foregroundColor(.orange)
//                            }
                        }
                        
                        Text(DateFormatter.longDateFormatter.string(from: deal.startingDate))
                        
                        // Deal is not completed
                        if let endingDate = deal.endingDate, !deal.isCompleted {
                            VStack(alignment: .leading) {
                                Text(DateFormatter.longDateFormatter.string(from: endingDate))
                            }
                        }
                        
                        Spacer()
                    }
                } else {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
    }
    
    // price
    fileprivate func priceView() -> some View {
        Group {
            Text((event.limitTotal ?? 0.0), format: .number) +
            Text(" ") +
            Text("руб.")
                .fontWeight(.heavy)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    // contragent
    fileprivate func contragentView() -> some View {
        VStack(alignment: .leading) {
            if let contragent = event.contragent {
                Text(contragent)
            }
            if let subcontractor = event.subcontractor {
                Text(subcontractor)
            }
            EmptyView()
        }
    }
    
    fileprivate func seniorView() -> some View {
        VStack {
            if let senior = event.senior {
                Text("\(senior)")
            } else {
                EmptyView()
            }
        }
    }
}


// MARK: - Preview Section

#Preview("Light Theme", traits: .sizeThatFitsLayout) {
    Group {
        EventRow(event: Event.example)
        EventRow(event: Event.example)
    }
    .preferredColorScheme(.light)
    .environmentObject(DealModel.example)
}

#Preview("Dark Theme", traits: .sizeThatFitsLayout) {
    Group {
        EventRow(event: Event.example)
        EventRow(event: Event.example)
    }
    .preferredColorScheme(.dark)
}
