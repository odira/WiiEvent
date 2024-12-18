import SwiftUI
import CoreLocation

public struct Deal: Hashable, Codable, Identifiable {
    
    // MARK: - Main parameters
    
    public var id: Int                //  0
    public var typeID: Int            //  1
    public var typeAbbr: String       //  2
    public var type: String           //  3
    public var isPlanning: Bool       //  4
    public var deal: String?          //  5
    public var startDate: Date        //  6
    public var stopDate: Date?        //  7
    public var note: String?          //  8
    public var dealID: Int?           //  9
    public var eventID: Int           // 10
    
//    public var shortName: String {
//        "OK"
//    }
    
    // MARK: - Initializations
    
    public init(
        id: Int,                      //  0
        typeID: Int,                  //  1
        typeAbbr: String,             //  2
        type: String,                 //  3
        isPlanning: Bool,             //  4
        deal: String? = nil,          //  5
        startDate: Date,              //  6
        stopDate: Date? = nil,        //  7
        note: String? = nil,          //  8
        dealID: Int? = nil,           //  9
        eventID: Int                  // 10
    ) {
        self.id = id                  //  0
        self.typeID = typeID          //  1
        self.typeAbbr = typeAbbr      //  2
        self.type = type              //  3
        self.isPlanning = isPlanning  //  4
        self.deal = deal              //  5
        self.startDate = startDate    //  6
        self.stopDate = stopDate      //  7
        self.note = note              //  8
        self.dealID = dealID          //  9
        self.eventID = eventID        // 10
    }
}

// MARK: - Event example

#if DEBUG
public extension Deal {
    
    static let example = samples[0]
    
    static let samples: [Deal] = [
        Deal(
            id: 10,                                              //  0
            typeID: 1,                                           //  1
            typeAbbr: "ДС",                                      //  2
            type: "Договор",                                     //  3
            isPlanning: false,                                   //  4
            deal: "ABC-1201",                                    //  5
            startDate: Date(timeIntervalSince1970: 1_000_000.0), //  6
            stopDate: Date(timeIntervalSinceNow: 0),             //  7
            note: "TEST",                                        //  8
            dealID: 11,                                          //  9
            eventID: 158                                         // 10
        )
    ]
    
}
#endif
