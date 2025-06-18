import PostgresClientKit
import SwiftUI
import Combine


// MARK: - HistoryModel definition


public class HistoryModel: ObservableObject {
   
    @Published public var histories = [History]()
    @Published public var isFetching: Bool = true
    
//    var optionalOnes: [Event] {
//        events.filter { $0.isOptional }
//    }
//
//    public var categories: [String: [Event]] {
//        Dictionary(
//            grouping: events,
//            by: { $0.category.rawValue }
//        )
//    }
//
//    public func getCategories() -> [String: [Event]] {
//        return Dictionary(
//            grouping: events,
//            by: { $0.category.rawValue }
//        )
//    }
   
    public init(histories: [History]) {
        self.histories = []
        self.histories = histories
    }
   
    public init() {
        self.histories = []
    }
   
    
    public func reload() async {
        await fetch()
    }
    
    @MainActor
    public func fetch() async {
        self.histories.removeAll()
        
        isFetching = true
        
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "217.107.219.91"
            configuration.database = "tercas"
            configuration.user = "postgres"
            configuration.credential = .trust // .scramSHA256(password: "monrepo")
            
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }
            
            let sqlText = "SELECT * FROM event.vw_history ORDER BY date"
            let statement = try connection.prepareStatement(text: sqlText)
            defer { statement.close() }
            
            let cursor = try statement.execute()
            defer { cursor.close() }
            
            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()            //  0
                let eventId = try columns[1].int()       //  1
                let datePg = try columns[2].date()       //  2
                let history = try columns[3].string()    //  3
                let note = try? columns[4].string()      //  4
                
                var date: Date {
                    /// The UTC/GMT time zone.
                    let utcTimeZone = TimeZone(secondsFromGMT: 0)!
                    return datePg.date(in: utcTimeZone)
                }
                
                histories.append(
                    History(
                        id: id,
                        eventId: eventId,
                        date: date,
                        history: history,
                        note: note ?? ""
                    )
                )
            }
            
        } catch {
            print(error)
        }
        
        isFetching = false
    }
}

// MARK: - HistoryModel example

#if DEBUG
public extension HistoryModel {
   
    static let historiesExmpls: [History] = [
        History.example,
        History.example
   ]
   
   static let example = samples[0]
   static let samples: [HistoryModel] = [
        HistoryModel(histories: historiesExmpls)
   ]
   
}
#endif


// MARK: - Additional Functions


public extension HistoryModel {
    
    func findHistoryById(id: Int) -> History? {
        let result = histories.filter { $0.id == id }
        if result.isEmpty {
            return nil
        }
        return result.first
    }
    
    func findFirstHistory(byEventId eventId: Int) -> History? {
        if let result = histories.first(where: { $0.eventId == eventId }) {
            return result
        }
        return nil
    }
    
    func findHistories(byEventId eventId: Int) -> [History]? {
        let result = histories.filter { $0.eventId == eventId }
        if result.isEmpty {
            return nil
        }
        return result
    }
    
}


// MARK: - DML SQL functions


extension HistoryModel {
    
    // MARK: - SQL INSERT
    
    public func sqlINSERT(
        eventId: Int,
        date: Date,
        history: String,
        note: String
    ) 
    async {
        
        let sqlQueryINSERT = """
            INSERT INTO
                event.vw_history(
                    event_id,
                    date,
                    history,
                    note
                )
            VALUES (
                    $1,   -- event_id
                    $2,   -- date
                    $3,   -- history
                    $4    -- note
            )
        """
        
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "217.107.219.91"
            configuration.database = "tercas"
            configuration.user = "postgres"
            configuration.credential = .trust // .scramSHA256(password: "monrepo")
            
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }
            
            let statement = try connection.prepareStatement(text: sqlQueryINSERT)
            defer { statement.close() }
            
            var datePg: PostgresDate {
                return date.postgresDate(in: TimeZone(secondsFromGMT: 0)!)
            }
            
            let _ = try statement.execute(
                parameterValues: [
                    eventId,
                    datePg,
                    history,
                    note
                ]
            )
        }
        catch {
            print(error)
        }
        
        await self.reload()
    }
    
    
    // MARK: - SQL UPDATE
    
    // Variant 1
    public func sqlUPDATE(
        id: Int,
        date: Date,
        history: String,
        note: String
    ) async {
        
        let sqlQueryUPDATE = """
            UPDATE
                event.vw_history
            SET
                date = $2,       -- date
                history = $3,    -- history
                note = $4        -- note
            WHERE
                id = $1          -- id
        """
        
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "217.107.219.91"
            configuration.database = "tercas"
            configuration.user = "postgres"
            configuration.credential = .trust // .scramSHA256(password: "monrepo")
            
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }
            
            let statement = try connection.prepareStatement(text: sqlQueryUPDATE)
            defer { statement.close() }
            
            
            var datePg: PostgresDate {
                return date.postgresDate(in: TimeZone(secondsFromGMT: 0)!)
            }
            
            let _ = try statement.execute(
                parameterValues: [
                    id,
                    datePg,
                    history,
                    note
                ]
            )
        }
        catch {
            print(error)
        }
        
        await self.reload()
    }
    
    // Variant 2
    public func sqlUPDATE(
        history: History
    ) async {
        
        let sqlQueryUPDATE = """
            UPDATE
                event.vw_history
            SET
                date = $2,       -- date
                history = $3,    -- history
                note = $4        -- note
            WHERE
                id = $1          -- id
        """
        
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "217.107.219.91"
            configuration.database = "tercas"
            configuration.user = "postgres"
            configuration.credential = .trust // .scramSHA256(password: "monrepo")
            
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }
            
            let statement = try connection.prepareStatement(text: sqlQueryUPDATE)
            defer { statement.close() }
            
            
            var datePg: PostgresDate {
                return history.date.postgresDate(in: TimeZone(secondsFromGMT: 0)!)
            }
            
            let _ = try statement.execute(
                parameterValues: [
                    history.id,
                    datePg,
                    history.history,
                    history.note
                ]
            )
        }
        catch {
            print(error)
        }
        
        await self.reload()
    }
    
    
    // MARK: - SQL DELETE
    
    public func sqlDELETE(
        historyId: Int
    ) async {
        
        let sqlQueryDELETE = """
            DELETE FROM
                event.vw_history
            WHERE
                id = $1     -- id
        """
        
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "217.107.219.91"
            configuration.database = "tercas"
            configuration.user = "postgres"
            configuration.credential = .trust // .scramSHA256(password: "monrepo")
            
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }
            
            let statement = try connection.prepareStatement(text: sqlQueryDELETE)
            defer { statement.close() }
            
            let _ = try statement.execute(
                parameterValues: [
                    historyId
                ]
            )
        }
        catch {
            print(error)
        }
        
        await self.reload()
    }
}
