import SwiftUI

struct SubgroupItemView: View {
    let subgroup: String
    
    var body: some View {
        Circle()
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.yellow)
                        .cornerRadius(20)
                    Text(subgroup)
                }
            }
    }
}

#Preview {
    SubgroupItemView(subgroup: Subgroup.example.subgroup)
}
