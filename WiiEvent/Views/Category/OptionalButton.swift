import SwiftUI

struct OptionalButton: View {
    
    @Binding var isOptional: Bool
    
    var body: some View {

        Text("ОПЦИОН".lowercased().capitalized)
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(.green)
            .bold()
            .padding(3)
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(.green, lineWidth: 1)
            }

    } // body
}

struct CompletedButton: View {
    
    @Binding var isCompleted: Bool
    
    var body: some View {

        Text("ВЫПОЛНЕН".lowercased().capitalized)
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(.red)
            .bold()
            .padding(3)
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(.red, lineWidth: 1)
            }

    } // body
}

#Preview {
    OptionalButton(isOptional: .constant(true))
    CompletedButton(isCompleted: .constant(true))
}
