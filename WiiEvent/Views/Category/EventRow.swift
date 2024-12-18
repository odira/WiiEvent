import SwiftUI

struct EventRow: View {
    
    var event: Event
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                if event.isOptional == true {
                    OptionalButton(isOptional: .constant(true))
                }
                if event.isCompleted == true {
                    CompletedButton(isCompleted: .constant(true))
                }
            }
            .frame(maxWidth: .infinity)
            
            HStack(alignment: .center) {
                Text(event.city ?? "")
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                event.image
                    .resizable()
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(event.contract ?? "")
                        .lineLimit(1)
                        .bold()
                        .font(.callout)
                    
                    Text(event.event)
                        .font(.footnote)
                        .bold()
                        .lineLimit(3)
                }
            }
        }
        .padding()
        // VStack
        
    }
}


#Preview("Light Theme") {
    EventRow(event: Event.example)
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
}

#Preview("Dark Theme") {
    EventRow(event: Event.example)
        .preferredColorScheme(.dark)
}

#Preview("Group") {
    Group {
        EventRow(event: Event.example)
        EventRow(event: Event.example)
    }
}
