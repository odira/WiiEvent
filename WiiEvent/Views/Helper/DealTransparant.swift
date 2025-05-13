import SwiftUI

struct OptionalButton: View {
    @Binding var isOptional: Bool
    
    var color: Color = .purple
    
    var body: some View {
//        Text("ОПЦИОН".lowercased().capitalized)
        Text("ОПЦИОН")
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(color)
            .bold()
            .padding(3)
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(color, lineWidth: 1)
            }
    }
}

//struct CompletedButton: View {
//    @Binding var isCompleted: Bool
//    
//    var body: some View {
////        Text("ВЫПОЛНЕН".lowercased().capitalized)
//        Text("ВЫПОЛНЕН")
//            .font(.system(.caption, design: .monospaced))
//            .foregroundStyle(.red)
//            .bold()
//            .padding(3)
//            .overlay {
//                RoundedRectangle(cornerRadius: 3)
//                    .stroke(.red, lineWidth: 1)
//            }
//    }
//}
//
//struct PlanningButton: View {
//    @Binding var isPlanning: Bool
//    var body: some View {
//        Text("ПЛАНИРУЕТСЯ")
//            .font(.system(.caption, design: .monospaced))
//            .foregroundStyle(.green)
//            .bold()
//            .padding(3)
//            .overlay {
//                RoundedRectangle(cornerRadius: 3)
//                    .stroke(.green, lineWidth: 1)
//            }
//    }
//}

struct DealStatusTransparant: View {
    var deal: Deal
    
    init(for deal: Deal) {
        self.deal = deal
    }
    
    var body: some View {
        deal.statusTransparant(for: deal)
    }
}

#Preview {
    OptionalButton(isOptional: .constant(true))
//    CompletedButton(isCompleted: .constant(true))
//    PlanningButton(isPlanning: .constant(true))
    DealStatusTransparant(for: Deal.example)
}
