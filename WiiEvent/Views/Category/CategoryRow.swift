import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Event]
    
    var body: some View {
        VStack(alignment: .leading) {
        
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { event in
                        NavigationLink {
//                            EventDetail(id: event.id)
                        } label: {
                            CategoryItem(event: event)
                        }
                    }
                }
            }
            .frame(height: 185)
            
        }
    } // body
}

#Preview {
    let events = EventModel.eventExamples
    return CategoryRow(
        categoryName: events[0].category.rawValue,
        items: Array(events.prefix(3))
    )
}
