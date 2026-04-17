import SwiftUI

public struct Deal: Hashable, Codable, Identifiable {
    public var id: Int                      //  0
    public var typeID: Int                  //  1
    public var typeAbbr: String             //  2
    public var type: String                 //  3
    public var statusID: Int                //  4
    public var deal: String?                //  5
    public var price: Double?               //  6
    public var startDate: Date              //  7
    public var endDate: Date?               //  8
    public var note: String?                //  9
    public var parentID: Int?               // 10
    public var eventID: Int                 // 11
    public var justificatoin: String?       // 12
    public var description: String?         // 13
    
    public init(
        id: Int,                            //  0
        typeID: Int,                        //  1
        typeAbbr: String,                   //  2
        type: String,                       //  3
        statusID: Int,                      //  4
        deal: String? = nil,                //  5
        price: Double? = nil,               //  6
        startDate: Date,                    //  7
        endDate: Date? = nil,               //  8
        note: String? = nil,                //  9
        parentID: Int? = nil,               // 10
        eventID: Int,                       // 11
        justification: String? = nil,       // 12
        description: String? = nil,         // 13
    ) {
        self.id = id                        //  0
        self.typeID = typeID                //  1
        self.typeAbbr = typeAbbr            //  2
        self.type = type                    //  3
        self.statusID = statusID            //  5
        self.deal = deal                    //  6
        self.startDate = startDate          //  7
        self.endDate = endDate              //  8
        self.note = note                    //  9
        self.parentID = parentID            // 10
        self.eventID = eventID              // 11
        self.justificatoin = justification  // 12
        self.description = description      // 13
    }
}

// MARK: - Deal extension for Status

public extension Deal {
    
    //    public var status: DealStatus {
    //        if isTerminated {
    //            return .terminated
    //        } else {
    //            switch (isPlanning, isCompleted) {
    //                case (true, false):
    //                    return .planning
    //                case (false, true):
    //                    return .completed
    //                default:
    //                    return .pending
    //            }
    //        }
    //    }
    
    enum Status: String, CaseIterable, Identifiable {
        case completed = "выполнен"
        case pending = "выполняется"
        case planning = "планируется"
        case terminated = "расторгнут"
        case canceled = "отменен"
        
        public var id: Int {
            switch self {
            case .completed: return 0
            case .planning: return 1
            case .pending: return 2
            case .terminated: return 4
            case .canceled: return 5
            }
        }
    }
    
    //    public var dealStatus: DealStatus {
    //        switch self.dealStatusID ?? 1 {
    //        case 0: return .completed
    //        case 2: return .pending
    //        case 1: return .planning
    //        case 4: return .terminated
    //        default: return .planning
    //        }
    //    }
    //    public var dealStatus: DealStatus? {
    //        guard let dealStatusID else { return nil }
    //        return DealStatus.allCases.first(where: { $0.rawValue == dealStatusID })
    //    }
        
    var status: Status {
        return .pending
    }
    
    var statusText: String {
        switch status {
        case .completed:  return "Выполнен"
        case .pending:    return "Выполняется"
        case .planning:   return "Планируется"
        case .terminated: return "Расторгнут"
        case .canceled:   return "Отменен"
        }
    }
    
    var statusColor: Color {
        switch status {
        case .completed:  return .orange
        case .pending:    return .green
        case .planning:   return .blue
        case .terminated: return .red
        case .canceled: return .brown
        }
    }
    
    func statusTransparant(for deal: Deal) -> some View {
        Text(deal.statusText)
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(deal.statusColor)
            .padding(3)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(deal.statusColor, lineWidth: 1)
            }
    }
    

}

// MARK: - Deal example

#if DEBUG
public extension Deal {
    
    static let example = samples[0]
    
    static let samples: [Deal] = [
        Deal(
            id: 10,                                               //  0
            typeID: 1,                                            //  1
            typeAbbr: "ДС",                                       //  2
            type: "Договор",                                      //  3
            statusID: 1,                                          //  4
            deal: "ABC-1201",                                     //  5
            price: 1_000_000.00,                                  //  6
            startDate: Date(timeIntervalSince1970: 1_000_000.0),  //  7
            endDate: Date(timeIntervalSinceNow: 0),               //  8
            note: "TEST",                                         //  9
            parentID: 11,                                         // 10
            eventID: 158,                                         // 11
            justification: "TEST",                                // 12
            description: "TEST",                                  // 13
        )
    ]
    
}
#endif
