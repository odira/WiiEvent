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
    @Published public var optionalStatus: OptionalStatus
    @Published public var showCompletedOnly: Bool
    @Published public var showPlan: String
    
    static let shared = Filters()
    
    init(
        optionalStatus: OptionalStatus = .all,
        showCompletedOnly: Bool = false,
        showPlan: String = ""
    ) {
        self.optionalStatus = optionalStatus
        self.showCompletedOnly = showCompletedOnly
        self.showPlan = showPlan
    }
}


class FilteredEvents: ObservableObject {
    @Published var filteredEvents: [Event] = [Event]()
    
    let model = EventModel.shared
    let filters = Filters.shared
    
    static let shared = FilteredEvents()
    
//    public var filteredEvents: [Event] {
//        model.events
//    }
    
    init() {
        filteredEvents = model.events
    }
}

//public     var filteredEvents: [Event] {
//    eventModel.events
//    
//        .filter { event in
//            (!showValidOnly || !event.isCompleted)
//        }
//    
//        .filter { event in
//            if !searchableText.isEmpty {
//                return event.city!.contains( searchableText )
//            } else {
//                return true
//            }
//        }
//    
//        .filter { event in
//            if optionalStatus == OptionalStatus.option {
//                return event.isOptional == true
//            } else if optionalStatus == OptionalStatus.main {
//                return event.isOptional == false
//            } else {
//                return true
//            }
//        }
//        
//        .filter { event in
//            (!showValidOnly || event.valid)
//        }
//    
//}


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
        .environmentObject(EventModel.example)
        .environmentObject(Filters())
}
