import SwiftUI
import CoreLocation

public struct History: Hashable, Codable, Identifiable {
    public var id: Int                     //  0
    public var eventID: Int                //  1
    public var date: Date                  //  2
    public var history: String             //  3
    public var note: String?               //  4
    public var letterNumReceiver: String?  //  5
    public var letterDateReceiver: Date?   //  6
    
    public init(
        id: Int,                           //  0
        eventID: Int,                      //  1
        date: Date,                        //  2
        history: String,                   //  3
        note: String? = nil,               //  4
        letterNumReceiver: String? = nil,  //  5
        letterDateReceiver: Date? = nil    //  6
    ) {
        self.id = id                                  //  0
        self.eventID = eventID                        //  1
        self.date = date                              //  2
        self.history = history                        //  3
        self.note = note                              //  4
        self.letterNumReceiver = letterNumReceiver    //  5
        self.letterDateReceiver = letterDateReceiver  //  6
    }
}

// MARK: - History example

#if DEBUG
public extension History {
    
    static let example = samples[0]
    
    static let samples: [History] = [
        History(
            id: 10,                                                     //  0
            eventID: 100,                                               //  1
            date: Date(timeIntervalSince1970: 1_000_000),               //  2
            history: "TEST HISTORY TEST HISTORY TEST",                  //  3
            note: "TEST HISTORY TEST HISTORY TEST",                     //  4
            letterNumReceiver: "Letter",                                //  5
            letterDateReceiver: Date(timeIntervalSince1970: 1_100_000)  //  6
        )
    ]
    
}
#endif
