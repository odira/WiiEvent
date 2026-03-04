//
//  PlanModel.swift
//  WiiEvent
//
//  Created by Vladimir Ilin on 14.07.2025.
//

import PostgresClientKit
import SwiftUI
import Combine

// MARK: - PlanModel definition

public class PlanModel: ObservableObject {
   
    @Published public var plans = [Plan]()
    @Published public var isFetching: Bool = true
    
    public init(plans: [Plan]) {
        self.plans = []
        self.plans = plans
    }
   
    public init() {
        self.plans = []
    }
   
    public func reload() async {
        await fetch()
    }
    
    @MainActor
    public func fetch() async {
        self.plans.removeAll()
        
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
                SELECT * FROM event.vw_plan
            """
            let statement = try connection.prepareStatement(text: sqlText)
            defer { statement.close() }
            
            let cursor = try statement.execute()
            defer { cursor.close() }
        
            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()           //  0
                let plan = try columns[1].string()      //  1
                let name = try? columns[2].string()     //  2
                let note = try? columns[3].string()     //  3
                
                plans.append(
                    Plan(
                        id: id,                         //  0
                        plan: plan,                     //  1
                        name: name,                     //  2
                        note: note                      //  3
                    )
                )
            }
            
        } catch {
            print(error)
        }
        
        isFetching = false
    }
}

// MARK: - PlanModel example

#if DEBUG
public extension PlanModel {
    static let planExmpls: [Plan] = [
        Plan.example,
        Plan.example
   ]
   
   static let example = samples[0]
   static let samples: [PlanModel] = [
        PlanModel(plans: planExmpls)
   ]
   
}
#endif

// MARK: - Additional Functions

public extension PlanModel {
    
    func findPlanByID(id: Int) -> Plan? {
        let result = plans.filter { $0.id == id }
        if result.isEmpty {
            return nil
        }
        return result.first
    }
}
    
//    func findFirstPlan(byEventId eventID: Int) -> Plan? {
//        if let result = plans.first(where: { $0.eventID == eventID }) {
//            return result
//        }
//        return nil
//    }
    
//    func findPlans(byEventID eventID: Int) -> [Plan]? {
//        let result = plans.filter { $0.eventID == eventID }
//        if result.isEmpty {
//            return nil
//        }
//        return result
//    }
    
//}


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
