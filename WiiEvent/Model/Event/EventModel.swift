import PostgresClientKit
import SwiftUI
import Combine
import WiiKit


public class EventModel: Identifiable, ObservableObject {
    
    @Published public var events = [Event]()
    @Published public var isFetching: Bool = true
    
    static let shared = EventModel()
    
    var optionalOnes: [Event] {
        events.filter { $0.isOptional }
    }
    
    public var categories: [String: [Event]] {
        Dictionary(
            grouping: events,
            by: { $0.category.rawValue }
        )
    }
    
    public func getCategories() -> [String: [Event]] {
        return Dictionary(
            grouping: events,
            by: { $0.category.rawValue }
        )
    }
    
    
    public init(events: [Event]) {
        self.events.removeAll()
        self.events = events
    }
    
    public init() {
        self.events.removeAll()
    }
    
    
    public func reload() async {
        await self.fetch()
    }
    
    @MainActor
    public func fetch() async {
        self.events.removeAll()
        
        self.isFetching = true
        
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "217.107.219.91"
            configuration.database = "tercas"
            configuration.user = "postgres"
            configuration.credential = .trust // .scramSHA256(password: "monrepo")
            
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }
            
            let sqlText = """
                SELECT
                    id,                    --  0
                    event,                 --  1
                    city,                  --  2
                    unit,                  --  3
                    equipment,             --  4
                    phase,                 --  5
                    years,                 --  6
                    end_date,              --  7
                    contragent,            --  8
                    subcontractor,         --  9
                    senior,                -- 10
                    end_morder,            -- 11
                    description,           -- 12
                    is_completed,          -- 13
                    is_optional,           -- 14
                    justification,         -- 15
                    price,                 -- 16
                    num_pz,                -- 17
                    note,                  -- 18
                    fp,                    -- 19
                    valid,                 -- 20
                    limit_2020,            -- 21
                    limit_2021,            -- 22
                    limit_2022,            -- 23
                    limit_2023,            -- 24
                    limit_2024,            -- 25
                    limit_2025,            -- 26
                    limit_2026,            -- 27
                    limit_2027,            -- 28
                    limit_2028,            -- 29
                    limit_2029,            -- 30
                    limit_2030,            -- 31
                    subgroup,              -- 32
                    subgroup_id            -- 33
                    -- deal_id_arr            -- 34
                FROM
                    event.vw_event
            """
            
            let statement = try connection.prepareStatement(text: sqlText)
            defer { statement.close() }
            
            let cursor = try statement.execute()
            defer { cursor.close() }
            
            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()                           //  0
                let event = try columns[1].string()                     //  1
                let city = try? columns[2].string()                     //  2
                let unit = try? columns[3].string()                     //  3
                let equipment = try? columns[4].string()                //  4
                let phase = try? columns[5].string()                    //  5
                let years = try? columns[6].string()                    //  6
                let endDate = try? columns[7].string()                  //  7
                let contragent = try? columns[8].string()               //  8
                let subcontractor = try? columns[9].string()           //  9
                let senior = try? columns[10].string()                  // 10
                let endMorder = try? columns[11].string()               // 11
                let description = try? columns[12].string()             // 12
                let isCompleted = try columns[13].bool()                // 13
                let isOptional = try columns[14].bool()                 // 14
                let justification = try? columns[15].string()           // 15
                let price = try? columns[16].decimal()                  // 16
                let numberPZ = try? columns[17].int()                   // 17
                let note = try? columns[18].string()                    // 18
                let fp = try? columns[19].string()                      // 19
                let valid = try columns[20].bool()                      // 20
                let limit2020 = try? columns[21].decimal()              // 21
                let limit2021 = try? columns[22].decimal()              // 22
                let limit2022 = try? columns[23].decimal()              // 23
                let limit2023 = try? columns[24].decimal()              // 24
                let limit2024 = try? columns[25].decimal()              // 25
                let limit2025 = try? columns[26].decimal()              // 26
                let limit2026 = try? columns[27].decimal()              // 27
                let limit2027 = try? columns[28].decimal()              // 28
                let limit2028 = try? columns[29].decimal()              // 29
                let limit2029 = try? columns[30].decimal()              // 30
                let limit2030 = try? columns[31].decimal()              // 31
                let subgroup = try? columns[32].string()                // 32
                let subgroupId = try? columns[33].int()                 // 33
//                let dealIDarr = try? columns[35].string().toIntArray()  // 35
                
                events.append(
                    Event(
                        id: id,                                       //  0
                        event: event,                                 //  1
                        city: city,                                   //  2
                        unit: unit,                                   //  3
                        equipment: equipment,                         //  4
                        phase: phase,                                 //  5
                        years: years,                                 //  6
                        endDate: endDate,                             //  7
                        contragent: contragent,                       //  8
                        subcontractor: subcontractor,                 //  9
                        senior: senior,                               // 10
                        endMorder: endMorder,                         // 11
                        description: description,                     // 12
                        isCompleted: isCompleted,                     // 13
                        isOptional: isOptional,                       // 14
                        justification: justification,                 // 15
                        price: price,                                 // 16
                        numberPZ: numberPZ,                           // 17
                        note: note,                                   // 18
                        fp: fp,                                       // 10
                        valid: valid,                                 // 20
                        limit2020: limit2020,                         // 21
                        limit2021: limit2021,                         // 22
                        limit2022: limit2022,                         // 23
                        limit2023: limit2023,                         // 24
                        limit2024: limit2024,                         // 25
                        limit2025: limit2025,                         // 26
                        limit2026: limit2026,                         // 27
                        limit2027: limit2027,                         // 28
                        limit2028: limit2028,                         // 29
                        limit2029: limit2029,                         // 30
                        limit2030: limit2030,                         // 31
                        subgroup: subgroup,                           // 32
                        subgroupId: subgroupId                        // 33
//                        dealIDarr: dealIDarr                          // 34
                    )
                )
            }
        } catch {
            print(error)
        } // do
        
        isFetching = false
    } // fetch
}


// MARK: - EventModel example

#if DEBUG
public extension EventModel {
    
    static let eventExamples: [Event] = [
        Event.example
    ]
    
    static let example = samples[0]
    static let samples: [EventModel] = [
        EventModel(events: eventExamples)
    ]
    
}
#endif


//// MARK: - DML SQL functions
//
//extension EventModel {
//    // MARK: - SQL INSERT
//    
//    public func sqlINSERT(_ event: Event) async {
//        let sqlQueryINSERT = """
//            INSERT INTO
//                person.vw_person(
//                    surname,
//                    name,
//                    middlename,
//                    sex,
//                    tab_num
//                )
//            VALUES (
//                    $1, -- surname
//                    $2, -- name
//                    $3, -- middlename
//                    $4, -- sex
//                    $5  -- tab_num
//            )
//        """
//        
//        do {
//            var configuration = PostgresClientKit.ConnectionConfiguration()
//            configuration.host = "217.107.219.91"
//            configuration.database = "tercas"
//            configuration.user = "postgres"
//            configuration.credential = .trust // .scramSHA256(password: "monrepo")
//            
//            let connection = try PostgresClientKit.Connection(configuration: configuration)
//            defer { connection.close() }
//            
//            let statement = try connection.prepareStatement(text: sqlQueryINSERT)
//            defer { statement.close() }
//            
//            let _ = try statement.execute(
//                parameterValues: [
//                    event,
//
//                ]
//            )
//        }
//        catch {
//            print(error)
//        }
//        
//        self.reload()
//    }
//}


// MARK: - Additional Functions

public extension EventModel {
    
    func findEventById(id: Int) -> Event? {
        let result = events.filter { $0.id == id }
        if result.isEmpty {
            return nil
        }
        return result.first
    }
}
