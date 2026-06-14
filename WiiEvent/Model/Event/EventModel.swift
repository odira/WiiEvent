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
                    id,                 --  0
                    event,              --  1
                    city,               --  2
                    unit,               --  3
                    equipment,          --  4
                    phase,              --  5
                    years,              --  6
                    end_date,           --  7
                    description,        --  8
                    is_completed,       --  9
                    is_option,          -- 10
                    justification,      -- 11
                    limit_total,        -- 12
                    note,               -- 13
                    plan_id,            -- 14
                    is_valid,           -- 15
                    limit_2020,         -- 16
                    limit_2021,         -- 17
                    limit_2022,         -- 18
                    limit_2023,         -- 19
                    limit_2024,         -- 20
                    limit_2025,         -- 21
                    limit_2026,         -- 22
                    limit_2027,         -- 23
                    limit_2028,         -- 24
                    limit_2029,         -- 25
                    limit_2030,         -- 26
                    subgroup,           -- 27
                    subgroup_id,        -- 28
                    status_id,          -- 29
                    deal_id,            -- 30
                    deal_type_id,       -- 31
                    deal_status_id,     -- 32
                    deal,               -- 33
                    deal_price,         -- 34
                    deal_start_date,    -- 35
                    deal_end_date,      -- 36
                    deal_contractor_id, -- 37
                    deal_contractor,    -- 38
                    deal_subcontractor, -- 39
                    deal_senior_id,     -- 40
                    deal_senior         -- 41
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
                
                let id = try columns[0].int()                     ///  0
                let event = try columns[1].string()               ///  1
                let city = try? columns[2].string()               ///  2
                let unit = try? columns[3].string()               ///  3
                let equipment = try? columns[4].string()          ///  4
                let phase = try? columns[5].string()              ///  5
                let years = try? columns[6].string()              ///  6
                let endDate = try? columns[7].string()            ///  7
                let description = try? columns[8].string()        ///  8
                let isCompleted = try columns[9].bool()           ///  9
                let isOption = try columns[10].bool()             /// 10
                let justification = try? columns[11].string()     /// 11
                let limitTotal = try? columns[12].decimal()       /// 12
                let note = try? columns[13].string()              /// 13
                let planId = try columns[14].int()                /// 14
                let isValid = try columns[15].bool()              /// 15
                let limit2020 = try? columns[16].decimal()        /// 16
                let limit2021 = try? columns[17].decimal()        /// 17
                let limit2022 = try? columns[18].decimal()        /// 18
                let limit2023 = try? columns[19].decimal()        /// 19
                let limit2024 = try? columns[20].decimal()        /// 20
                let limit2025 = try? columns[21].decimal()        /// 21
                let limit2026 = try? columns[22].decimal()        /// 22
                let limit2027 = try? columns[23].decimal()        /// 23
                let limit2028 = try? columns[24].decimal()        /// 24
                let limit2029 = try? columns[25].decimal()        /// 25
                let limit2030 = try? columns[26].decimal()        /// 26
                let subgroup = try? columns[27].string()          /// 27
                let subgroupId = try? columns[28].int()           /// 28
                let statusID = try? columns[29].int()             /// 29
                let dealID = try? columns[30].int()               /// 30
                let dealTypeID = try? columns[31].int()           /// 31
                let dealStatusID = try columns[32].int()          /// 32
                let deal = try? columns[33].string()              /// 33
                let dealPrice = try? columns[34].decimal()        /// 34
                let dealStartDatePg = try? columns[35].date()     /// 35
                let dealEndDatePg = try? columns[36].date()       /// 36
                let dealContractorID = try? columns[37].int()     /// 37
                let dealContractor = try? columns[38].string()    /// 38
                let dealSubcontractor = try? columns[39].string() /// 39
                let dealSeniorID = try? columns[40].int()         /// 40
                let dealSenior = try? columns[41].string()        /// 41
                
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
                        id: id,                                 ///  0
                        event: event,                           ///  1
                        city: city,                             ///  2
                        unit: unit,                             ///  3
                        equipment: equipment,                   ///  4
                        phase: phase,                           ///  5
                        years: years,                           ///  6
                        endDate: endDate,                       ///  7
                        description: description,               ///  8
                        isCompleted: isCompleted,               ///  9
                        isOption: isOption,                     /// 10
                        justification: justification,           /// 11
                        limitTotal: limitTotal,                 /// 12
                        note: note,                             /// 13
                        planId: planId,                         /// 14
                        isValid: isValid,                       /// 15
                        limit2020: limit2020,                   /// 16
                        limit2021: limit2021,                   /// 17
                        limit2022: limit2022,                   /// 18
                        limit2023: limit2023,                   /// 19
                        limit2024: limit2024,                   /// 20
                        limit2025: limit2025,                   /// 21
                        limit2026: limit2026,                   /// 22
                        limit2027: limit2027,                   /// 23
                        limit2028: limit2028,                   /// 24
                        limit2029: limit2029,                   /// 25
                        limit2030: limit2030,                   /// 26
                        subgroup: subgroup,                     /// 27
                        subgroupId: subgroupId,                 /// 28
                        statusID: statusID,                     /// 29
                        dealID: dealID,                         /// 30
                        dealTypeID: dealTypeID,                 /// 31
                        dealStatusID: dealStatusID,             /// 32
                        deal: deal,                             /// 33
                        dealPrice: dealPrice,                   /// 34
                        dealStartDate: dealStartDate,           /// 35
                        dealEndDate: dealEndDate,               /// 36
                        dealContractorID: dealContractorID,     /// 37
                        dealContractor: dealContractor,         /// 38
                        dealSubcontractor: dealSubcontractor,   /// 39
                        dealSeniorID: dealSeniorID,             /// 40
                        dealSenior: dealSenior                  /// 41
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
