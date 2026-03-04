import SwiftUI


public enum OptionalStatus: String, CaseIterable, Identifiable {
    case all
    case main
    case option
    
    public var label: String {
        switch self {
        case .all:    return "все"
        case .main:   return "основной"
        case .option: return "опцион"
        }
    }

    public var id: String { self.rawValue }
}


// MARK: -- Filters Class

public class Filters: ObservableObject {
    @Published public var optionalStatus: OptionalStatus = .all
    @Published public var showCompletedOnly: Bool = false
    @Published public var showPlan: String = ""
}


// MARK: -- Filters View

struct FiltersView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var filters: Filters
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Централизованный план - Все/Основной/Опцион
                Picker("Все/Основной/Опцион", selection: $filters.optionalStatus) {
                    ForEach(OptionalStatus.allCases) { status in
                        Text(status.label.capitalized)
                            .tag(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Toggle(isOn: $filters.showCompletedOnly) {
                    Text("Завершенные")
                }
                TextField("Год", text: $filters.showPlan)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                
                Button("Press to dismiss") {
                    dismiss()
                }
                .font(.title)
                .padding()
                .background(.black)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    FiltersView()
        .environmentObject(Filters())
}
