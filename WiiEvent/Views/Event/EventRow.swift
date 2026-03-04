import SwiftUI

struct EventRow: View {
    @EnvironmentObject private var dealModel: DealModel
    
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
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
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // event
    fileprivate func eventView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.event)
                    .font(.footnote)
                    .bold()
                    .lineLimit(3)
            }
            Spacer()
        }
    }
    
    // deal
    fileprivate func dealView() -> some View {
        HStack {
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
            
            Spacer()
        }
    }
    
    // price
    fileprivate func priceView() -> some View {
        HStack {
            Group {
                Text((event.limitTotal ?? 0.0), format: .number) +
                Text(" ") +
                Text("руб.")
                    .fontWeight(.heavy)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
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
    
    fileprivate func seniorView() -> some View {
        HStack {
            VStack {
                if let senior = event.senior {
                    Text("\(senior)")
                } else {
                    EmptyView()
                }
            }
            
            Spacer()
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
        EventRow(event: Event.example)
    }
    .preferredColorScheme(.dark)
}
