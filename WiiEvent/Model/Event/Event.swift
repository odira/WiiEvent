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
    public var contragent: String?        //  8
    public var subcontractor: String?     //  9
    public var senior: String?            // 10
    public var endMorder: String?         // 11
    public var description: String?       // 12
    public var isCompleted: Bool          // 13
    public var isOptional: Bool           // 14
    public var justification: String?     // 15
    public var price: Decimal?            // 16
    public var numberPZ: Int?             // 17
    public var note: String?              // 18
    public var fp: String?                // 19
    public var valid: Bool                // 20
    public var limit2020: Decimal?        // 21
    public var limit2021: Decimal?        // 22
    public var limit2022: Decimal?        // 23
    public var limit2023: Decimal?        // 24
    public var limit2024: Decimal?        // 25
    public var limit2025: Decimal?        // 26
    public var limit2026: Decimal?        // 27
    public var limit2027: Decimal?        // 28
    public var limit2028: Decimal?        // 29
    public var limit2029: Decimal?        // 30
    public var limit2030: Decimal?        // 31
    public var subgroup: String?          // 32
    public var subgroupId: Int?           // 33
//    public var dealIDarr: [Int]?          // 35
    
    // Composed parameters
    
    public enum Category: String, CaseIterable, Codable {
        case completed = "Completed"
        case pending = "Pending"
        case planned = "Planned"
        case mess = "Mess"
    }
    public var category: Category {
//        if let endMorder {
//            return Category.completed
//        }
        
        if isCompleted == true {
            return Category.completed
        }
        
        return Category.planned
    }
    
    private var imageName: String?
    public var image: Image {
        if let imageName {
            Image(imageName)
        } else {
            Image(systemName: "nosign")
        }
    }

//    var planImage: Image? {
//        if let plan {
//            return Image(systemName: plan)
//        } else {
//            return Image(systemName: "paperplan")
//        }
//    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    private var coordinates: Coordinates = Coordinates(latitude: 0.55, longitude: 0.35)
    public var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude, 
            longitude: coordinates.longitude
        )
    }

    
    // MARK: - Initializations
    
    public init(
        id: Int,                              //  0
        event: String,                        //  1
        city: String? = nil,                  //  2
        unit: String? = nil,                  //  3
        equipment: String? = nil,             //  4
        phase: String? = nil,                 //  5
        years: String? = nil,                 //  6
        endDate: String? = nil,               //  7
        contragent: String? = nil,            //  8
        subcontractor: String? = nil,         //  9
        senior: String? = nil,                // 10
        endMorder: String? = nil,             // 11
        description: String? = nil,           // 12
        isCompleted: Bool,                    // 13
        isOptional: Bool,                     // 14
        justification: String? = nil,         // 15
        price: Decimal? = nil,                // 16
        numberPZ: Int? = nil,                 // 17
        note: String? = nil,                  // 18
        fp: String? = nil,                    // 19
        valid: Bool,                          // 20
        limit2020: Decimal? = nil,            // 21
        limit2021: Decimal? = nil,            // 22
        limit2022: Decimal? = nil,            // 23
        limit2023: Decimal? = nil,            // 24
        limit2024: Decimal? = nil,            // 25
        limit2025: Decimal? = nil,            // 26
        limit2026: Decimal? = nil,            // 27
        limit2027: Decimal? = nil,            // 28
        limit2028: Decimal? = nil,            // 29
        limit2029: Decimal? = nil,            // 30
        limit2030: Decimal? = nil,            // 31
        subgroup: String? = nil,              // 32
        subgroupId: Int? = nil                // 33
//        dealIDarr: [Int]? = nil               // 35
    ) {
        self.id = id                          //  0
        self.event = event                    //  1
        self.city = city                      //  2
        self.unit = unit                      //  3
        self.equipment = equipment            //  4
        self.phase = phase                    //  5
        self.years = years                    //  6
        self.endDate = endDate                //  7
        self.contragent = contragent          //  8
        self.subcontractor = subcontractor    //  9
        self.senior = senior                  // 10
        self.endMorder = endMorder            // 11
        self.description = description        // 12
        self.isCompleted = isCompleted        // 13
        self.isOptional = isOptional          // 14
        self.justification = justification    // 15
        self.price = price                    // 16
        self.numberPZ = numberPZ              // 17
        self.note = note                      // 18
        self.fp = fp                          // 19
        self.valid = valid                    // 20
        self.limit2020 = limit2020            // 21
        self.limit2021 = limit2021            // 22
        self.limit2022 = limit2022            // 23
        self.limit2023 = limit2023            // 24
        self.limit2024 = limit2024            // 25
        self.limit2025 = limit2025            // 26
        self.limit2026 = limit2026            // 27
        self.limit2027 = limit2027            // 28
        self.limit2028 = limit2028            // 29
        self.limit2029 = limit2029            // 30
        self.limit2030 = limit2030            // 31
        self.subgroup = subgroup              // 32
        self.subgroupId = subgroupId          // 33
//        self.dealIDarr = dealIDarr            // 35
    }
}


// MARK: - Event example

#if DEBUG
public extension Event {
    
    static let example = samples[0]
    static let samples: [Event] = [
        Event(id: 3,                                //  0
              event: "Sample event",                  //  1
              city: "Воронеж",                        //  2
              unit: "РегЦ",                           //  3
              equipment: "АС ОрВД",                   //  4
              phase: "Пусконаладка",                  //  5
              years: "2023-2030",                     //  6
              endDate: "2023-01-01",                  //  7
              contragent: "Алмаз-Антей",              //  8
              subcontractor: "Алмаз-Антей",           //  9
              senior: "Пугачев",                      // 10
              endMorder: "№ 151",                     // 11
              description: "Тестовая комбинация",     // 12
              isCompleted: true,                      // 13
              isOptional: true,                       // 14
              justification: "По щучьему велению",    // 15
              price: 1000.00,                         // 16
              numberPZ: 555_666,                      // 17
              note: "NOTE TEST",                      // 18
              fp: "ЦП СОиМО",                         // 19
              valid: true,                            // 20
              limit2020: 2020,                        // 21
              limit2021: 2021,                        // 22
              limit2022: 2022,                        // 23
              limit2023: 2023,                        // 24
              limit2024: 2024,                        // 25
              limit2025: 2025,                        // 26
              limit2026: 2026,                        // 27
              limit2027: 2027,                        // 28
              limit2028: 2028,                        // 29
              limit2029: 2029,                        // 30
              limit2030: 2030,                        // 31
              subgroup: "SUB",                        // 32
              subgroupId: 0                           // 33
//              dealIDarr: [100, 200]                   // 34
        )
    ]
    
}
#endif
