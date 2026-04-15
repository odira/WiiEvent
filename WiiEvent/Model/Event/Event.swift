import Foundation
import SwiftUI
import CoreLocation

public struct Event: Hashable, Codable, Identifiable {
    public var id: Int                  ///  0
    public var event: String            ///  1
    public var city: String?            ///  2
    public var unit: String?            ///  3
    public var equipment: String?       ///  4
    public var phase: String?           ///  5
    public var years: String?           ///  6
    public var endDate: String?         ///  7
    public var contragent: String?      ///  8
    public var subcontractor: String?   ///  9
    public var senior: String?          /// 10
    public var description: String?     /// 11
    public var isCompleted: Bool        /// 12
    public var isOption: Bool           /// 13
    public var justification: String?   /// 14
    public var limitTotal: Decimal?     /// 15
    public var note: String?            /// 16
    public var planId: Int              /// 17
    public var isValid: Bool            /// 18
    public var limit2020: Decimal?      /// 19
    public var limit2021: Decimal?      /// 20
    public var limit2022: Decimal?      /// 21
    public var limit2023: Decimal?      /// 22
    public var limit2024: Decimal?      /// 23
    public var limit2025: Decimal?      /// 24
    public var limit2026: Decimal?      /// 25
    public var limit2027: Decimal?      /// 26
    public var limit2028: Decimal?      /// 27
    public var limit2029: Decimal?      /// 28
    public var limit2030: Decimal?      /// 29
    public var subgroup: String?        /// 30
    public var subgroupId: Int?         /// 31
    public var statusID: Int?           /// 32
    public var dealID: Int?             /// 33
    public var dealTypeID: Int?         /// 34
    public var dealStatusID: Int?       /// 35
    public var deal: String?            /// 36
    public var dealPrice: Decimal?      /// 37
    public var dealStartDate: Date?     /// 38
    public var dealEndDate: Date?       /// 39
    
    enum Status: String, CaseIterable {
        case planning = "планируется"   /// 1
        case pending = "выполняется"    /// 2
        case completed = "завершено"    /// 3
        case terminated = "прекращено"  /// 4
        case undefined = "неопределено" /// 5
    }
    var status: Status {
        switch self.statusID ?? 5 {  /// 'неопределено' defined in PostgreSQL tercase database as value 5
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
    
    var dealStatus: Deal.Status? {
        guard let dealStatusID else { return nil }
        
        switch dealStatusID {
        case 0: return .completed
        case 1: return .planning
        case 2: return .pending
        case 4: return .terminated
        default: return nil
        }
    }
    var dealStatusText: String {
        switch dealStatus {
        case .completed:  return "Выполнен"
        case .pending:    return "Выполняется"
        case .planning:   return "Планируется"
        case .terminated: return "Расторгнут"
        default: return "Планируется"
        }
    }
    var dealStatusColor: Color {
        switch dealStatus {
        case .completed:  return .orange
        case .pending:    return .green
        case .planning:   return .blue
        case .terminated: return .red
        default: return .blue
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
 
public extension Event {
    init(
        id: Int,                              ///  0
        event: String,                        ///  1
        city: String? = nil,                  ///  2
        unit: String? = nil,                  ///  3
        equipment: String? = nil,             ///  4
        phase: String? = nil,                 ///  5
        years: String? = nil,                 ///  6
        endDate: String? = nil,               ///  7
        contragent: String? = nil,            ///  8
        subcontractor: String? = nil,         ///  9
        senior: String? = nil,                /// 10
        description: String? = nil,           /// 11
        isCompleted: Bool,                    /// 12
        isOption: Bool,                       /// 13
        justification: String? = nil,         /// 14
        limitTotal: Decimal? = nil,           /// 15
        note: String? = nil,                  /// 16
        planId: Int,                          /// 17
        isValid: Bool,                        /// 18
        limit2020: Decimal? = nil,            /// 19
        limit2021: Decimal? = nil,            /// 20
        limit2022: Decimal? = nil,            /// 21
        limit2023: Decimal? = nil,            /// 22
        limit2024: Decimal? = nil,            /// 23
        limit2025: Decimal? = nil,            /// 24
        limit2026: Decimal? = nil,            /// 25
        limit2027: Decimal? = nil,            /// 26
        limit2028: Decimal? = nil,            /// 27
        limit2029: Decimal? = nil,            /// 28
        limit2030: Decimal? = nil,            /// 29
        subgroup: String? = nil,              /// 30
        subgroupId: Int? = nil,               /// 31
        statusID: Int? = nil,                 /// 32
        dealID: Int? = nil,                   /// 33
        dealTypeID: Int? = nil,               /// 34
        dealStatusID: Int? = nil,             /// 35
        deal: String? = nil,                  /// 36
        dealPrice: Decimal? = nil,            /// 37
        dealStartDate: Date? = nil,           /// 38
        dealEndDate: Date? = nil              /// 39
    ) {
        self.id = id                          ///  0
        self.event = event                    ///  1
        self.city = city                      ///  2
        self.unit = unit                      ///  3
        self.equipment = equipment            ///  4
        self.phase = phase                    ///  5
        self.years = years                    ///  6
        self.endDate = endDate                ///  7
        self.contragent = contragent          ///  8
        self.subcontractor = subcontractor    ///  9
        self.senior = senior                  /// 10
        self.description = description        /// 11
        self.isCompleted = isCompleted        /// 12
        self.isOption = isOption              /// 13
        self.justification = justification    /// 14
        self.limitTotal = limitTotal          /// 15
        self.note = note                      /// 16
        self.planId = planId                  /// 17
        self.isValid = isValid                /// 18
        self.limit2020 = limit2020            /// 19
        self.limit2021 = limit2021            /// 20
        self.limit2022 = limit2022            /// 21
        self.limit2023 = limit2023            /// 22
        self.limit2024 = limit2024            /// 23
        self.limit2025 = limit2025            /// 24
        self.limit2026 = limit2026            /// 25
        self.limit2027 = limit2027            /// 26
        self.limit2028 = limit2028            /// 27
        self.limit2029 = limit2029            /// 28
        self.limit2030 = limit2030            /// 29
        self.subgroup = subgroup              /// 30
        self.subgroupId = subgroupId          /// 31
        self.statusID = statusID              /// 32
        self.dealID = dealID                  /// 33
        self.dealTypeID = dealTypeID          /// 34
        self.dealStatusID = dealStatusID      /// 35
        self.deal = deal                      /// 36
        self.dealPrice = dealPrice            /// 37
        self.dealStartDate = dealStartDate    /// 38
        self.dealEndDate = dealEndDate        /// 39
    }
}

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
              contragent: "Алмаз-Антей",              ///  8
              subcontractor: "Алмаз-Антей",           ///  9
              senior: "Пугачев",                      /// 10
              description: "Тестовая комбинация",     /// 11
              isCompleted: true,                      /// 12
              isOption: true,                         /// 13
              justification: "По щучьему велению",    /// 14
              limitTotal: 1000.00,                    /// 15
              note: "NOTE TEST",                      /// 16
              planId: 1,                              /// 17
              isValid: true,                          /// 18
              limit2020: 2020,                        /// 19
              limit2021: 2021,                        /// 20
              limit2022: 2022,                        /// 21
              limit2023: 2023,                        /// 22
              limit2024: 2024,                        /// 23
              limit2025: 2025,                        /// 24
              limit2026: 2026,                        /// 25
              limit2027: 2027,                        /// 26
              limit2028: 2028,                        /// 27
              limit2029: 2029,                        /// 28
              limit2030: 2030,                        /// 29
              subgroup: "SUB",                        /// 30
              subgroupId: 0,                          /// 31
              statusID: 0,                            /// 32
              dealID: 100,                            /// 33
              dealTypeID: 1,                          /// 34
              dealStatusID: 1,                        /// 35
              deal: "Москва-Резерв",                  /// 36
              dealPrice: 1000.00,                     /// 37
              dealStartDate: Date(timeIntervalSince1970: 1000),   /// 38
              dealEndDate: Date(timeIntervalSince1970: 2000)      /// 39
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
