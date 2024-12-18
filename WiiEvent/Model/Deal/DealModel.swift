import PostgresClientKit
import SwiftUI
import Combine


// MARK: - DealModel definition

public class DealModel: ObservableObject {
   
    @Published public var deals = [Deal]()
    @Published public var isFetching: Bool = true
    
   
    public init(deals: [Deal]) {
        self.deals = []
        self.deals = deals
    }
   
    public init() {
        self.deals = []
    }
   
    
    public func reload() async {
        await fetch()
    }
    
    @MainActor
    public func fetch() async {
        self.deals.removeAll()
        
        isFetching = true
        
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "217.107.219.91"
            configuration.database = "tercas"
            configuration.user = "postgres"
            configuration.credential = .trust // .scramSHA256(password: "monrepo")
            
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }
            
            let sqlText = "SELECT * FROM deal.vw_deal ORDER BY start ASC"
            let statement = try connection.prepareStatement(text: sqlText)
            defer { statement.close() }
            
            let cursor = try statement.execute()
            defer { cursor.close() }
            
            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()                //  0
                let typeID = try columns[1].int()            //  1 
                let typeAbbr = try columns[2].string()       //  2
                let type = try columns[3].string()           //  3
                let isPlanning = try columns[4].bool()       //  4
                let deal = try? columns[5].string()          //  5
                let startDatePg = try columns[6].date()      //  6
                let stopDatePg = try? columns[7].date()      //  7
                let note = try? columns[8].string()          //  8
                let dealID = try? columns[9].int()           //  9
                let eventID = try columns[10].int()          // 10
                
                var startDate: Date {
                    /// The UTC/GMT time zone.
                    let utcTimeZone = TimeZone(secondsFromGMT: 0)!
                    return startDatePg.date(in: utcTimeZone)
                }
                
                var stopDate: Date? {
                    if let stopDatePg {
                        /// The UTC/GMT time zone.
                        let utcTimeZone = TimeZone(secondsFromGMT: 0)!
                        return stopDatePg.date(in: utcTimeZone)
                    } else {
                        return nil
                    }
                }
                
                deals.append(
                    Deal(
                        id: id,                      //  0
                        typeID: typeID,              //  1
                        typeAbbr: typeAbbr,          //  2
                        type: type,                  //  3
                        isPlanning: isPlanning,      //  4
                        deal: deal,                  //  5
                        startDate: startDate,        //  6
                        stopDate: stopDate,          //  7
                        note: note,                  //  8
                        dealID: dealID,              //  9
                        eventID: eventID             // 10
                    )
                )
            }
            
        } catch {
            print(error)
        }
        
        isFetching = false
        
    } // fetch()
}


// MARK: - DealModel example

#if DEBUG
public extension DealModel {
   
    static let dealsExmpls: [Deal] = [
        Deal.example,
        Deal.example
   ]
   
   static let example = samples[0]
   static let samples: [DealModel] = [
        DealModel(deals: dealsExmpls)
   ]
   
}
#endif


// MARK: - Additional Functions


public extension DealModel {
    
    func findDealByID(id: Int) -> Deal? {
        let result = deals.filter { $0.id == id }
        if result.isEmpty {
            return nil
        }
        return result.first
    }
    
    func findFirstDeal(byEventId eventID: Int) -> Deal? {
        if let result = deals.first(where: { $0.eventID == eventID }) {
            return result
        }
        return nil
    }
    
    func findDeals(byEventID eventID: Int) -> [Deal]? {
        let result = deals.filter { $0.eventID == eventID }
        if result.isEmpty {
            return nil
        }
        return result
    }
    
}


// MARK: - DML SQL functions


//extension DealModel {
//    
//    // MARK: - SQL INSERT
//    
//    public func sqlINSERT(
//        eventId: Int,
//        date: Date,
//        history: String,
//        note: String
//    )
//    async {
//        
//        let sqlQueryINSERT = """
//            INSERT INTO
//                event.vw_history(
//                    event_id,
//                    date,
//                    history,
//                    note
//                )
//            VALUES (
//                    $1,   -- event_id
//                    $2,   -- date
//                    $3,   -- history
//                    $4    -- note
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
//            var datePg: PostgresDate {
//                return date.postgresDate(in: TimeZone(secondsFromGMT: 0)!)
//            }
//            
//            let _ = try statement.execute(
//                parameterValues: [
//                    eventId,
//                    datePg,
//                    history,
//                    note
//                ]
//            )
//        }
//        catch {
//            print(error)
//        }
//        
//        await self.reload()
//    }
//    
//    
//    // MARK: - SQL UPDATE
//    
//    // Variant 1
//    public func sqlUPDATE(
//        id: Int,
//        date: Date,
//        history: String,
//        note: String
//    ) async {
//        
//        let sqlQueryUPDATE = """
//            UPDATE
//                event.vw_history
//            SET
//                date = $2,       -- date
//                history = $3,    -- history
//                note = $4        -- note
//            WHERE
//                id = $1          -- id
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
//            let statement = try connection.prepareStatement(text: sqlQueryUPDATE)
//            defer { statement.close() }
//            
//            
//            var datePg: PostgresDate {
//                return date.postgresDate(in: TimeZone(secondsFromGMT: 0)!)
//            }
//            
//            let _ = try statement.execute(
//                parameterValues: [
//                    id,
//                    datePg,
//                    history,
//                    note
//                ]
//            )
//        }
//        catch {
//            print(error)
//        }
//        
//        await self.reload()
//    }
//    
//    // Variant 2
//    public func sqlUPDATE(
//        history: History
//    ) async {
//        
//        let sqlQueryUPDATE = """
//            UPDATE
//                event.vw_history
//            SET
//                date = $2,       -- date
//                history = $3,    -- history
//                note = $4        -- note
//            WHERE
//                id = $1          -- id
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
//            let statement = try connection.prepareStatement(text: sqlQueryUPDATE)
//            defer { statement.close() }
//            
//            
//            var datePg: PostgresDate {
//                return history.date.postgresDate(in: TimeZone(secondsFromGMT: 0)!)
//            }
//            
//            let _ = try statement.execute(
//                parameterValues: [
//                    history.id,
//                    datePg,
//                    history.history,
//                    history.note
//                ]
//            )
//        }
//        catch {
//            print(error)
//        }
//        
//        await self.reload()
//    }
//    
//    
//    // MARK: - SQL DELETE
//    
//    public func sqlDELETE(
//        historyId: Int
//    ) async {
//        
//        let sqlQueryDELETE = """
//            DELETE FROM
//                event.vw_history
//            WHERE
//                id = $1     -- id
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
//            let statement = try connection.prepareStatement(text: sqlQueryDELETE)
//            defer { statement.close() }
//            
//            let _ = try statement.execute(
//                parameterValues: [
//                    historyId
//                ]
//            )
//        }
//        catch {
//            print(error)
//        }
//        
//        await self.reload()
//    }
//}
