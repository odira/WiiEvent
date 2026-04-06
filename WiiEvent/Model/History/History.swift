import SwiftUI
import CoreLocation

// MARK: - History definition

public struct History: Hashable, Codable, Identifiable {
    
    public var id: Int                  //  0
    public var eventId: Int             //  1
    public var date: Date               //  2
    public var history: String          //  3
    public var note: String?            //  4
    public var letter1: String?         //  5
    public var letter1date: Date?       //  6
    public var letter1note: String?     //  7
    public var letter1unit: Int?        //  8
    public var letter2: String?         //  9
    public var letter2date: Date?       // 10
    public var letter2note: String?     // 11
    public var letter2unit: Int?        // 12
    public var inOut: String?           // 13
    
    public init(
        id: Int,                        //  0
        eventId: Int,                   //  1
        date: Date,                     //  2
        history: String,                //  3
        note: String? = "",             //  4
        letter1: String? = nil,         //  5
        letter1date: Date? = nil,       //  6
        letter1note: String? = nil,     //  7
        letter1unit: Int? = nil,        //  8
        letter2: String? = nil,         //  9
        letter2date: Date? = nil,       // 10
        letter2note: String? = nil,     // 11
        letter2unit: Int? = nil,        // 12
        inOut: String? = nil            // 13
    ) {
        self.id = id                    //  0
        self.eventId = eventId          //  1
        self.date = date                //  2
        self.history = history          //  3
        self.note = note                //  4
        self.letter1 = letter1          //  5
        self.letter1date = letter1date  //  6
        self.letter1note = letter1note  //  7
        self.letter1unit = letter1unit  //  8
        self.letter2 = letter2          //  9
        self.letter2date = letter2date  // 10
        self.letter2note = letter2note  // 11
        self.letter2unit = letter2unit  // 12
        self.inOut = inOut              // 13
    }
}

// MARK: - History example

#if DEBUG
public extension History {
    
    static let example = samples[0]
    
    static let samples: [History] = [
        History(
            id: 10,                                               //  0
            eventId: 100,                                         //  1
            date: Date(timeIntervalSince1970: 1_000_000),         //  2
            history: "TEST HISTORY TEST HISTORY TEST",            //  3
            note: "TEST HISTORY TEST HISTORY TEST",               //  4
            letter1: "Letter One",                                //  5
            letter1date: Date(timeIntervalSince1970: 1_100_000),  //  6
            letter1note: "Letter One NOTE",                       //  7
            letter1unit: 10,                                      //  8
            letter2: "Letter Two",                                //  9
            letter2date: Date(timeIntervalSince1970: 1_200_000),  // 10
            letter2note: "Letter Two NOTE",                       // 11
            letter2unit: 20,                                      // 12
            inOut: "IN"                                           // 13
        )
    ]
    
}
#endif
