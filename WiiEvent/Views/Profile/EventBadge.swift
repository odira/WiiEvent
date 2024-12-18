import SwiftUI

struct EventBadge: View {
    var name: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "trash.fill")
                .resizable()
                .frame(width: 300, height: 300)
                .scaleEffect(1.0 / 3.0)
                .frame(width: 100, height: 100)
            Text(name)
                .font(.caption)
                .accessibilityLabel("Badge for \(name)")
        }
    }
}

#Preview {
    EventBadge(name: "Preview Testing")
}
