import PostgresClientKit
import SwiftUI
import Combine
import WiiKit
import SwiftData

// MARK: - DEFINITION

public class EventModel: Identifiable, ObservableObject {
    @Published public var isFetching: Bool = true
    @Published public var events = [Event]()
    @Published public var filteredEvents: [Event] = []
    
    @Published public var filter = EventModelFilter()
    
    static let shared = EventModel()
    
    // INITIALIZATION
    //
    init() {
        self.events = []
    }
    
    init(events: [Event]) {
        self.events.removeAll()
        self.events = events
    }
    
    // DEINITIALIZATION
    //
    deinit {
        self.events.removeAll()
    }
    
    // OTHER
    //
    @MainActor
    func reload() async {
        self.events.removeAll()
        await self.fetch()
    }
    
    @MainActor
    func fetch() async {
        self.isFetching = true
        
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "217.107.219.91"
            configuration.database = "tercas"
            configuration.user = "postgres"
            configuration.credential = .trust // .scramSHA256(password: "monrepo")
            
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer {
                connection.close()
            }
            
            let sqlText = """
                SELECT
                    id,               --  0
                    event,            --  1
                    city,             --  2
                    unit,             --  3
                    equipment,        --  4
                    phase,            --  5
                    years,            --  6
                    end_date,         --  7
                    manufacturer_id,  --  8
                    contragent,       --  9
                    subcontractor,    -- 10
                    senior,           -- 11
                    description,      -- 12
                    is_completed,     -- 13
                    is_option,        -- 14
                    justification,    -- 15
                    limit_total,      -- 16
                    note,             -- 17
                    plan_id,          -- 18
                    is_valid,         -- 19
                    limit_2020,       -- 20
                    limit_2021,       -- 21
                    limit_2022,       -- 22
                    limit_2023,       -- 23
                    limit_2024,       -- 24
                    limit_2025,       -- 25
                    limit_2026,       -- 26
                    limit_2027,       -- 27
                    limit_2028,       -- 28
                    limit_2029,       -- 29
                    limit_2030,       -- 30
                    subgroup,         -- 31
                    subgroup_id,      -- 32
                    status_id,        -- 33
                    deal_id,          -- 34
                    deal_type_id,     -- 35
                    deal_status_id,   -- 36
                    deal,             -- 37
                    deal_price,       -- 38
                    deal_start_date,  -- 39
                    deal_end_date     -- 40
                FROM
                    event.vw_event
            """
            
            let statement = try connection.prepareStatement(text: sqlText)
            defer {
                statement.close()
            }
            
            let cursor = try statement.execute()
            defer {
                cursor.close()
            }
            
            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()                     //  0
                let event = try columns[1].string()               //  1
                let city = try? columns[2].string()               //  2
                let unit = try? columns[3].string()               //  3
                let equipment = try? columns[4].string()          //  4
                let phase = try? columns[5].string()              //  5
                let years = try? columns[6].string()              //  6
                let endDate = try? columns[7].string()            //  7
                let manufacturerID = try? columns[8].int()        //  8
                let contragent = try? columns[9].string()         //  9
                let subcontractor = try? columns[10].string()      // 10
                let senior = try? columns[11].string()            // 11
                let description = try? columns[12].string()       // 12
                let isCompleted = try columns[13].bool()          // 13
                let isOption = try columns[14].bool()             // 14
                let justification = try? columns[15].string()     // 15
                let limitTotal = try? columns[16].decimal()       // 16
                let note = try? columns[17].string()              // 17
                let planId = try columns[18].int()                // 18
                let isValid = try columns[19].bool()              // 19
                let limit2020 = try? columns[20].decimal()        // 20
                let limit2021 = try? columns[21].decimal()        // 21
                let limit2022 = try? columns[22].decimal()        // 22
                let limit2023 = try? columns[23].decimal()        // 23
                let limit2024 = try? columns[24].decimal()        // 24
                let limit2025 = try? columns[25].decimal()        // 25
                let limit2026 = try? columns[26].decimal()        // 26
                let limit2027 = try? columns[27].decimal()        // 27
                let limit2028 = try? columns[28].decimal()        // 28
                let limit2029 = try? columns[29].decimal()        // 29
                let limit2030 = try? columns[30].decimal()        // 30
                let subgroup = try? columns[31].string()          // 31
                let subgroupId = try? columns[32].int()           // 32
                let statusID = try? columns[33].int()             // 33
                let dealID = try? columns[34].int()               // 34
                let dealTypeID = try? columns[35].int()           // 35
                let dealStatusID = try columns[36].int()          // 36
                let deal = try? columns[37].string()              // 37
                let dealPrice = try? columns[38].decimal()        // 38
                let dealStartDatePg = try? columns[39].date()     // 39
                let dealEndDatePg = try? columns[40].date()       // 40
                
                // The UTC/GMT time zone.
                let utcTimeZone = TimeZone(secondsFromGMT: 0)!
                
                var dealStartDate: Date? {
                    if let date = dealStartDatePg {
                        return date.date(in: utcTimeZone)
                    }
                    return nil
                }
                var dealEndDate: Date? {
                    if let date = dealEndDatePg {
                        return date.date(in: utcTimeZone)
                    }
                    return nil
                }
                
                events.append(
                    Event(
                        id: id,                                   //  0
                        event: event,                             //  1
                        city: city,                               //  2
                        unit: unit,                               //  3
                        equipment: equipment,                     //  4
                        phase: phase,                             //  5
                        years: years,                             //  6
                        endDate: endDate,                         //  7
                        manufacturerID: manufacturerID,           //  8
                        contragent: contragent,                   //  9
                        subcontractor: subcontractor,             // 10
                        senior: senior,                           // 11
                        description: description,                 // 12
                        isCompleted: isCompleted,                 // 13
                        isOption: isOption,                       // 14
                        justification: justification,             // 15
                        limitTotal: limitTotal,                   // 16
                        note: note,                               // 17
                        planId: planId,                           // 18
                        isValid: isValid,                         // 19
                        limit2020: limit2020,                     // 20
                        limit2021: limit2021,                     // 21
                        limit2022: limit2022,                     // 22
                        limit2023: limit2023,                     // 23
                        limit2024: limit2024,                     // 24
                        limit2025: limit2025,                     // 25
                        limit2026: limit2026,                     // 26
                        limit2027: limit2027,                     // 27
                        limit2028: limit2028,                     // 28
                        limit2029: limit2029,                     // 29
                        limit2030: limit2030,                     // 30
                        subgroup: subgroup,                       // 31
                        subgroupId: subgroupId,                   // 32
                        statusID: statusID,                       // 33
                        dealID: dealID,                           // 34
                        dealTypeID: dealTypeID,                   // 35
                        dealStatusID: dealStatusID,               // 36
                        deal: deal,                               // 37
                        dealPrice: dealPrice,                     // 39
                        dealStartDate: dealStartDate,             // 39
                        dealEndDate: dealEndDate                  // 40
                    )
                )
            }
        } catch {
            print(error)
        }
        
        isFetching = false
    }
}

// MARK: - EventModel Example extension

#if DEBUG
public extension EventModel {
    
    static let eventExamples: [Event] = [
        Event.example,
        Event.example,
        Event.example
    ]
    
    static let example = samples[0]
    static let samples: [EventModel] = [
        EventModel(events: eventExamples),
        EventModel(events: eventExamples),
        EventModel(events: eventExamples)
    ]
    
}
#endif

public extension EventModel {
    func findEventById(_ id: Int) -> Event? {
        let result = events.filter { $0.id == id }
        if result.isEmpty {
            return nil
        } else {
            return result.first
        }
    }
}
