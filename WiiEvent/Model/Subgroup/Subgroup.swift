import SwiftUI
import CoreLocation


// MARK: - Subgroup definition

public struct Subgroup: Hashable, Codable, Identifiable {
    
    // MARK: - Main parameters
    
    public var id: Int                    //  0
    public var subgroup: String           //  1
    public var abbr: String               //  2
    public var description: String?       //  3
    public var note: String?              //  4
    
    // MARK: - Initializations
    
    public init(
        id: Int,                          //  0
        subgroup: String,                 //  1
        abbr: String,                     //  2
        description: String? = nil,       //  3
        note: String? = nil               //  4
    ) {
        self.id = id                      //  0
        self.subgroup = subgroup          //  1
        self.abbr = abbr                  //  2
        self.description = description    //  3
        self.note = note                  //  4
    }
}


// MARK: - Event example

#if DEBUG
public extension Subgroup {
    
    static let example = samples[0]
    static let samples: [Subgroup] = [
        Subgroup(id: 100,                              //  0
                 subgroup: "Внедрение МПСН",           //  1
                 abbr: "МПСН",                         //  2
                 description: "Внедрение МПСН TEST",   //  3
                 note: "МПСЕ TEST"                     //  4
        )
    ]
    
}
#endif
