import Foundation
import SwiftUI
import CoreLocation

public struct Event: Hashable, Codable, Identifiable {
    public var id: Int                    //  0
    public var event: String              //  1
    public var city: String?              //  2
    public var unit: String?              //  3
    public var equipment: String?         //  4
    public var phase: String?             //  5
    public var years: String?             //  6
    public var endDate: String?           //  7
    ///
    public var manufacturerID: Int?       //  8
    public var contragent: String?        //  9
    public var subcontractor: String?     // 10
    ///
    public var senior: String?            // 11
    public var description: String?       // 12
    public var isCompleted: Bool          // 13
    public var isOption: Bool             // 14
    public var justification: String?     // 15
    public var limitTotal: Decimal?       // 16
    public var note: String?              // 17
    public var planId: Int                // 18
    public var isValid: Bool              // 19
    public var limit2020: Decimal?        // 20
    public var limit2021: Decimal?        // 21
    public var limit2022: Decimal?        // 22
    public var limit2023: Decimal?        // 23
    public var limit2024: Decimal?        // 24
    public var limit2025: Decimal?        // 25
    public var limit2026: Decimal?        // 26
    public var limit2027: Decimal?        // 27
    public var limit2028: Decimal?        // 28
    public var limit2029: Decimal?        // 29
    public var limit2030: Decimal?        // 30
    public var subgroup: String?          // 31
    public var subgroupId: Int?           // 32
    ///
    public var statusID: Int?             // 33
    ///public var status: String?            // 34
    ///
    public var dealID: Int?               // 34
    public var dealTypeID: Int?           // 35
    public var dealStatusID: Int          // 36
    public var deal: String?              // 37
    public var dealPrice: Decimal?        // 38
    public var dealStartDate: Date?       // 39
    public var dealEndDate: Date?         // 40
    
    
    enum Status: String, CaseIterable {
        case planning   = "планируется"   // 1
        case pending    = "выполняется"   // 2
        case completed  = "завершено"     // 3
        case terminated = "прекращено"    // 4
        case undefined  = "неопределено"  // 5
    }
    var status: Status {
        switch self.statusID ?? 5 {  // 'неопределено' defined in PostgreSQL tercase database as value 5
            case 1: return .planning
            case 2: return .pending
            case 3: return .completed
            case 4: return .terminated
            default: return .undefined
        }
    }
    
    private var imageName: String?
    public var image: Image {
        if let imageName {
            Image(imageName)
        } else {
            Image(systemName: "nosign")
        }
    }
}

public extension Event {
    enum DealTypeAbbr: String, CaseIterable {
        case deal = "Договор"
        case contract = "Контракт"
        case additional = "ДС"
    }
    var dealTypeAbbr: DealTypeAbbr? {
        guard let dealTypeID else { return nil }
        
        switch dealTypeID {
        case 1: return .deal
        case 2: return .contract
        case 3: return .additional
        default: return nil
        }
    }
    var dealTypeAbbrText: String {
        switch dealTypeAbbr {
        case .deal:       return "Договор"
        case .contract:   return "Контракт"
        case .additional: return "ДС"
        default: return ""
        }
    }
    
    
    var dealStatus: Deal.Status {
        switch dealStatusID {
        case 0: return .completed
        case 1: return .planning
        case 2: return .pending
        case 4: return .terminated
        case 5: return .canceled
            default: return .planning
        }
//        return Deal.Status.ID { where: status == dealStatusID }
    }
    var dealStatusText: String {
        return dealStatus.rawValue
    }
    var dealStatusColor: Color {
        switch dealStatus {
        case .completed:  return .orange
        case .pending:    return .green
        case .planning:   return .blue
        case .terminated: return .red
        case .canceled:   return .brown
        }
    }
    
    func dealStatusTransparant(event: Event) -> some View {
        Text(dealStatusText)
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(dealStatusColor)
            .padding(3)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(dealStatusColor, lineWidth: 1)
            }
    }
}

// MARK: - Initializations
 
//public extension Event {
//    init(
//        id: Int,                              ///  0
//        event: String,                        ///  1
//        city: String? = nil,                  ///  2
//        unit: String? = nil,                  ///  3
//        equipment: String? = nil,             ///  4
//        phase: String? = nil,                 ///  5
//        years: String? = nil,                 ///  6
//        endDate: String? = nil,               ///  7
//        manufacturerID: Int? = nil,           ///  8
//        contragent: String? = nil,            ///  9
//        subcontractor: String? = nil,         /// 10
//        senior: String? = nil,                /// 11
//        description: String? = nil,           /// 12
//        isCompleted: Bool,                    /// 13
//        isOption: Bool,                       /// 14
//        justification: String? = nil,         /// 15
//        limitTotal: Decimal? = nil,           /// 16
//        note: String? = nil,                  /// 17
//        planId: Int,                          /// 18
//        isValid: Bool,                        /// 19
//        limit2020: Decimal? = nil,            /// 20
//        limit2021: Decimal? = nil,            /// 21
//        limit2022: Decimal? = nil,            /// 22
//        limit2023: Decimal? = nil,            /// 23
//        limit2024: Decimal? = nil,            /// 24
//        limit2025: Decimal? = nil,            /// 25
//        limit2026: Decimal? = nil,            /// 26
//        limit2027: Decimal? = nil,            /// 27
//        limit2028: Decimal? = nil,            /// 28
//        limit2029: Decimal? = nil,            /// 29
//        limit2030: Decimal? = nil,            /// 30
//        subgroup: String? = nil,              /// 31
//        subgroupId: Int? = nil,               /// 32
//        statusID: Int? = nil,                 /// 33
//        ///
//        dealID: Int? = nil,                   /// 34
//        dealTypeID: Int? = nil,               /// 35
//        dealStatusID: Int = 1,                /// 36
//        deal: String? = nil,                  /// 37
//        dealPrice: Decimal? = nil,            /// 38
//        dealStartDate: Date? = nil,           /// 39
//        dealEndDate: Date? = nil              /// 40
//    ) {
//        self.id = id                          ///  0
//        self.event = event                    ///  1
//        self.city = city                      ///  2
//        self.unit = unit                      ///  3
//        self.equipment = equipment            ///  4
//        self.phase = phase                    ///  5
//        self.years = years                    ///  6
//        self.endDate = endDate                ///  7
//        self.manufacturerID = manufacturerID  ///  8
//        self.contragent = contragent          ///  9
//        self.subcontractor = subcontractor    /// 10
//        self.senior = senior                  /// 11
//        self.description = description        /// 12
//        self.isCompleted = isCompleted        /// 13
//        self.isOption = isOption              /// 14
//        self.justification = justification    /// 15
//        self.limitTotal = limitTotal          /// 16
//        self.note = note                      /// 17
//        self.planId = planId                  /// 18
//        self.isValid = isValid                /// 19
//        self.limit2020 = limit2020            /// 20
//        self.limit2021 = limit2021            /// 21
//        self.limit2022 = limit2022            /// 22
//        self.limit2023 = limit2023            /// 23
//        self.limit2024 = limit2024            /// 24
//        self.limit2025 = limit2025            /// 25
//        self.limit2026 = limit2026            /// 26
//        self.limit2027 = limit2027            /// 27
//        self.limit2028 = limit2028            /// 28
//        self.limit2029 = limit2029            /// 29
//        self.limit2030 = limit2030            /// 30
//        self.subgroup = subgroup              /// 31
//        self.subgroupId = subgroupId          /// 32
//        self.statusID = statusID              /// 33
//        ///
//        self.dealID = dealID                  /// 34
//        self.dealTypeID = dealTypeID          /// 35
//        self.dealStatusID = dealStatusID      /// 36
//        self.deal = deal                      /// 37
//        self.dealPrice = dealPrice            /// 38
//        self.dealStartDate = dealStartDate    /// 39
//        self.dealEndDate = dealEndDate        /// 40
//    }
//}

// MARK: - Event example

#if DEBUG
public extension Event {
    static let example = samples[0]
    static let samples: [Event] = [
        Event(id: 12,                                 ///  0
              event: "Sample event",                  ///  1
              city: "Воронеж",                        ///  2
              unit: "РегЦ",                           ///  3
              equipment: "АС ОрВД",                   ///  4
              phase: "Пусконаладка",                  ///  5
              years: "2023-2030",                     ///  6
              endDate: "2023-01-01",                  ///  7
              manufacturerID: 6,                      ///  8
              contragent: "Алмаз-Антей",              ///  9
              subcontractor: "Алмаз-Антей",           /// 10
              senior: "Пугачев",                      /// 11
              description: "Тестовая комбинация",     /// 12
              isCompleted: true,                      /// 13
              isOption: true,                         /// 14
              justification: "По щучьему велению",    /// 15
              limitTotal: 1000.00,                    /// 16
              note: "NOTE TEST",                      /// 17
              planId: 1,                              /// 18
              isValid: true,                          /// 19
              limit2020: 2020,                        /// 20
              limit2021: 2021,                        /// 21
              limit2022: 2022,                        /// 22
              limit2023: 2023,                        /// 23
              limit2024: 2024,                        /// 24
              limit2025: 2025,                        /// 25
              limit2026: 2026,                        /// 26
              limit2027: 2027,                        /// 27
              limit2028: 2028,                        /// 28
              limit2029: 2029,                        /// 29
              limit2030: 2030,                        /// 30
              subgroup: "SUB",                        /// 31
              subgroupId: 0,                          /// 32
              statusID: 0,                            /// 33
              dealID: 100,                            /// 34
              dealTypeID: 1,                          /// 35
              dealStatusID: 1,                        /// 36
              deal: "Москва-Резерв",                  /// 37
              dealPrice: 1000.00,                     /// 38
              dealStartDate: Date(timeIntervalSince1970: 1000),   /// 39
              dealEndDate: Date(timeIntervalSince1970: 2000)      /// 40
        )
    ]
    
}
#endif

// MARK: -

public extension Event {
    func statusTransparant(for event: Event) -> some View {
        Text(event.status.rawValue.uppercased())
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(.gray)
            .padding(3)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 1)
            }
    }
    
    func isOptionTransparant(for event: Event) -> some View {
        Text("опцион".uppercased())
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(.cyan)
            .padding(3)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.cyan, lineWidth: 1)
            }
    }
}
