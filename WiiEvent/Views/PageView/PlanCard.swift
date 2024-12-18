import SwiftUI

struct PlanCard: View {
    var event: Event
    
    var body: some View {
//        event.planImage?
//            .resizable()
//            .overlay {
//                TextOverlay(event: event)
//            }
        VStack {
            
        }
    }
}

struct TextOverlay: View {
    var event: Event
    
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            VStack(alignment: .leading) {
                Text(event.event)
                    .font(.title)
                    .bold()
//                Text(event.contract ?? "")
            }
            .padding()
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    PlanCard(event: EventModel.example.events[0])
        .aspectRatio(3 / 2, contentMode: .fit)
}
