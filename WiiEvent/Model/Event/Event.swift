import Foundation
import SwiftUI
import CoreLocation

// MARK: - Definition And Initialization By Default

public struct Event: Hashable, Codable, Identifiable {
    public var id: Int                    ///  0
    public var event: String              ///  1
    public var city: String?              ///  2
    public var unit: String?              ///  3
    public var equipment: String?         ///  4
    public var phase: String?             ///  5
    public var years: String?             ///  6
    public var endDate: String?           ///  7
    public var description: String?       ///  8
    public var isCompleted: Bool          ///  9
    public var isOption: Bool             /// 10
    public var justification: String?     /// 11
    public var limitTotal: Decimal?       /// 12
    public var note: String?              /// 13
    public var planId: Int                /// 14
    public var isValid: Bool              /// 15
    public var limit2020: Decimal?        /// 16
    public var limit2021: Decimal?        /// 17
    public var limit2022: Decimal?        /// 18
    public var limit2023: Decimal?        /// 19
    public var limit2024: Decimal?        /// 20
    public var limit2025: Decimal?        /// 21
    public var limit2026: Decimal?        /// 22
    public var limit2027: Decimal?        /// 23
    public var limit2028: Decimal?        /// 24
    public var limit2029: Decimal?        /// 25
    public var limit2030: Decimal?        /// 26
    public var subgroup: String?          /// 27
    public var subgroupId: Int?           /// 28
    ///
    public var statusID: Int?             /// 29
    ///public var status: String?            // 34
    ///
    public var dealID: Int?               /// 30
    public var dealTypeID: Int?           /// 31
    public var dealStatusID: Int          /// 32
    public var deal: String?              /// 33
    public var dealPrice: Decimal?        /// 34
    public var dealStartDate: Date?       /// 35
    public var dealEndDate: Date?         /// 36
    public var dealContractorID: Int?     /// 37
    public var dealContractor: String?    /// 38
    public var dealSubcontractor: String? /// 39
    public var dealSeniorID: Int?         /// 40
    public var dealSenior: String?        /// 41
    
    enum Status: String, CaseIterable {
        case planning   = "планируется"   /// 1
        case pending    = "выполняется"   /// 2
        case completed  = "завершено"     /// 3
        case terminated = "прекращено"    /// 4
        case undefined  = "неопределено"  /// 5
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

// MARK: - Event example

#if DEBUG
public extension Event {
    static let example = samples[0]
    static let samples: [Event] = [
        Event(id: 12,                                            ///  0
              event: "Sample event",                             ///  1
              city: "Воронеж",                                   ///  2
              unit: "РегЦ",                                      ///  3
              equipment: "АС ОрВД",                              ///  4
              phase: "Пусконаладка",                             ///  5
              years: "2023-2030",                                ///  6
              endDate: "2023-01-01",                             ///  7
              description: "Тестовая комбинация",                ///  8
              isCompleted: true,                                 ///  9
              isOption: true,                                    /// 10
              justification: "По щучьему велению",               /// 11
              limitTotal: 1000.00,                               /// 12
              note: "NOTE TEST",                                 /// 13
              planId: 1,                                         /// 14
              isValid: true,                                     /// 15
              limit2020: 2020,                                   /// 16
              limit2021: 2021,                                   /// 17
              limit2022: 2022,                                   /// 18
              limit2023: 2023,                                   /// 19
              limit2024: 2024,                                   /// 20
              limit2025: 2025,                                   /// 21
              limit2026: 2026,                                   /// 22
              limit2027: 2027,                                   /// 23
              limit2028: 2028,                                   /// 24
              limit2029: 2029,                                   /// 25
              limit2030: 2030,                                   /// 26
              subgroup: "SUB",                                   /// 27
              subgroupId: 0,                                     /// 28
              statusID: 0,                                       /// 29
              dealID: 100,                                       /// 30
              dealTypeID: 1,                                     /// 31
              dealStatusID: 1,                                   /// 32
              deal: "Москва-Резерв",                             /// 33
              dealPrice: 1000.00,                                /// 34
              dealStartDate: Date(timeIntervalSince1970: 1000),  /// 35
              dealEndDate: Date(timeIntervalSince1970: 2000),    /// 36
              dealContractorID: 6,                               /// 37
              dealContractor: "Алмаз-Антей",                     /// 38
              dealSubcontractor: "Алмаз-Антей",                  /// 39
              dealSeniorID: 5,                                   /// 40
              dealSenior: "Пугачев",                             /// 41
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
