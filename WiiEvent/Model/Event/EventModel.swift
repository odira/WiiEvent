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
                    contragent,       --  8
                    subcontractor,    --  9
                    senior,           -- 10
                    description,      -- 11
                    is_completed,     -- 12
                    is_option,        -- 13
                    justification,    -- 14
                    limit_total,      -- 15
                    note,             -- 16
                    plan_id,          -- 17
                    is_valid,         -- 18
                    limit_2020,       -- 19
                    limit_2021,       -- 20
                    limit_2022,       -- 21
                    limit_2023,       -- 22
                    limit_2024,       -- 23
                    limit_2025,       -- 24
                    limit_2026,       -- 25
                    limit_2027,       -- 26
                    limit_2028,       -- 27
                    limit_2029,       -- 28
                    limit_2030,       -- 29
                    subgroup,         -- 30
                    subgroup_id,      -- 31
                    status_id,        -- 32
                    deal_id,          -- 33
                    deal              -- 34
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
                let contragent = try? columns[8].string()         //  8
                let subcontractor = try? columns[9].string()      //  9
                let senior = try? columns[10].string()            // 10
                let description = try? columns[11].string()       // 11
                let isCompleted = try columns[12].bool()          // 12
                let isOption = try columns[13].bool()             // 13
                let justification = try? columns[14].string()     // 14
                let limitTotal = try? columns[15].decimal()       // 15
                let note = try? columns[16].string()              // 16
                let planId = try columns[17].int()                // 17
                let isValid = try columns[18].bool()              // 18
                let limit2020 = try? columns[19].decimal()        // 19
                let limit2021 = try? columns[20].decimal()        // 20
                let limit2022 = try? columns[21].decimal()        // 21
                let limit2023 = try? columns[22].decimal()        // 22
                let limit2024 = try? columns[23].decimal()        // 23
                let limit2025 = try? columns[24].decimal()        // 24
                let limit2026 = try? columns[25].decimal()        // 25
                let limit2027 = try? columns[26].decimal()        // 26
                let limit2028 = try? columns[27].decimal()        // 27
                let limit2029 = try? columns[28].decimal()        // 28
                let limit2030 = try? columns[29].decimal()        // 29
                let subgroup = try? columns[30].string()          // 30
                let subgroupId = try? columns[31].int()           // 31
                let statusId = try? columns[32].int()             // 32
                let dealId = try? columns[33].int()               // 33
                let deal = try? columns[34].string()              // 34
                
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
                        contragent: contragent,                   //  8
                        subcontractor: subcontractor,             //  9
                        senior: senior,                           // 10
                        description: description,                 // 11
                        isCompleted: isCompleted,                 // 12
                        isOption: isOption,                       // 13
                        justification: justification,             // 14
                        limitTotal: limitTotal,                   // 15
                        note: note,                               // 16
                        planId: planId,                           // 17
                        isValid: isValid,                         // 18
                        limit2020: limit2020,                     // 19
                        limit2021: limit2021,                     // 20
                        limit2022: limit2022,                     // 21
                        limit2023: limit2023,                     // 22
                        limit2024: limit2024,                     // 23
                        limit2025: limit2025,                     // 24
                        limit2026: limit2026,                     // 25
                        limit2027: limit2027,                     // 26
                        limit2028: limit2028,                     // 27
                        limit2029: limit2029,                     // 28
                        limit2030: limit2030,                     // 29
                        subgroup: subgroup,                       // 30
                        subgroupId: subgroupId,                   // 31
                        statusId: statusId,                       // 32
                        dealId: dealId,                           // 33
                        deal: deal                                // 34
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
