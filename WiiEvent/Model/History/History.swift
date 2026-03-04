import SwiftUI
import CoreLocation

// MARK: - History definition

public struct History: Hashable, Codable, Identifiable {
    
    public var id: Int                //  0
    public var eventId: Int           //  1
    public var date: Date             //  2
    public var history: String        //  3
    public var note: String           //  4
    
    public init(
        id: Int,                      //  0
        eventId: Int,                 //  1
        date: Date,                   //  2
        history: String,              //  3
        note: String                  //  4
    ) {
        self.id = id                  //  0
        self.eventId = eventId        //  1
        self.date = date              //  2
        self.history = history        //  3
        self.note = note              //  4
    }
}

// MARK: - History example

#if DEBUG
public extension History {
    
    static let example = samples[0]
    
    static let samples: [History] = [
        History(
            id: 10,                                          //  0
            eventId: 100,                                    //  1
            date: Date(timeIntervalSince1970: 1_000_000),    //  2
            history: "TEST HISTORY TEST HISTORY TEST",       //  3
            note: "TEST HISTORY TEST HISTORY TEST"           //  4
        )
    ]
    
}
#endif
