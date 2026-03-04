import SwiftUI

struct CategoryItem: View {
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            
            event.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(5)
            
            Text(event.event)
                .foregroundStyle(.primary)
                .font(.caption)
                .frame(width: 100)
            
        }
        .padding(.leading, 15)
    } // body
}

#Preview {
    CategoryItem(event: EventModel.eventExamples[0])
}
