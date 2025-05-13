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
            
            let sqlText = """
                SELECT
                    * 
                FROM 
                    deal.vw_deal
                ORDER BY 
                    starting_date ASC
            """
            let statement = try connection.prepareStatement(text: sqlText)
            defer { statement.close() }
            
            let cursor = try statement.execute()
            defer { cursor.close() }
        
            
            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()                   ///    0
                let typeID = try columns[1].int()               ///    1
                let typeAbbr = try columns[2].string()          ///    2
                let type = try columns[3].string()              ///    3
                let isPlanning = try columns[4].bool()          ///    4
                let isCompleted = try columns[5].bool()         ///    5
                let deal = try? columns[6].string()             ///    6
                let startingDatePg = try columns[7].date()      ///    7
                let endingDatePg = try? columns[8].date()       ///    8
                let note = try? columns[9].string()             ///    9
                let parentID = try? columns[10].int()           ///   10
                let eventID = try columns[11].int()             ///   11
                let justification = try? columns[12].string()   ///   12
                let description = try? columns[13].string()     ///   13
                

                var startingDate: Date {
                    let utcTimeZone = TimeZone(secondsFromGMT: 0)!  ///  UTC/GMT time zone
                    return startingDatePg.date(in: utcTimeZone)
                }
                
                var endingDate: Date? {
                    if let endingDatePg {
                        let utcTimeZone = TimeZone(secondsFromGMT: 0)!  ///  UTC/GMT time zone
                        return endingDatePg.date(in: utcTimeZone)
                    } else {
                        return nil
                    }
                }
                
                deals.append(
                    Deal(
                        id: id,                        //   0
                        typeID: typeID,                //   1
                        typeAbbr: typeAbbr,            //   2
                        type: type,                    //   3
                        isPlanning: isPlanning,        //   4
                        isCompleted: isCompleted,      //   5
                        deal: deal,                    //   6
                        startingDate: startingDate,    //   7
                        endingDate: endingDate,        //   8
                        note: note,                    //   9
                        parentID: parentID,            //  10
                        eventID: eventID,              //  11
                        justification: justification,  //  12
                        description: description       //  13
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
        print(result)
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
