//
//  InformationModel.swift
//  WiiEvent
//
//  Created by Vladimir Ilin on 24.08.2025.
//

import PostgresClientKit
import SwiftUI
import Combine

// MARK: - Model Definition

class InfoModel: ObservableObject {
    @Published public var infos = [Info]()
    @Published public var isFetching: Bool = true
    
    public init(infos: [Info]) {
        self.infos = infos
    }
   
    public init() {
        self.infos = []
    }
    
    deinit {
        self.infos.removeAll()
    }
   
    public func reload() async {
        self.infos.removeAll()
        await fetch()
    }
    
    @MainActor
    public func fetch() async {
        self.infos.removeAll()
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
                    id,         -- 0
                    info,       -- 1
                    date,       -- 2
                    event_id,   -- 3
                    note        -- 4
                FROM 
                    event.vw_info
                ORDER BY 
                    date ASC
            """
            let statement = try connection.prepareStatement(text: sqlText)
            defer { statement.close() }
            
            let cursor = try statement.execute()
            defer { cursor.close() }
        
            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()            //  0
                let info = try columns[1].string()       //  1
                let datePg = try columns[2].date()       //  2
                let eventID = try columns[3].int()       //  3
                let note = try? columns[4].string()      //  4
                
                var date: Date {
                    let utcTimeZone = TimeZone(secondsFromGMT: 0)!       // UTC/GMT time zone
                    return datePg.date(in: utcTimeZone)
                }
                
                infos.append(
                    Info(
                        id: id,              //  0
                        info: info,          //  1
                        date: date,          //  2
                        eventID: eventID,    //  3
                        note: note ?? ""     //  4
                    )
                )
            }
            
        } catch {
            print(error)
        }
        
        isFetching = false
    }
}

// MARK: - InfoModel example

#if DEBUG
extension InfoModel {
   
    public static let infosExmpls: [Info] = [
        Info.example,
        Info.example
   ]
   
   public static let example = samples[0]
   public static let samples: [InfoModel] = [
        InfoModel(infos: infosExmpls)
   ]
   
}
#endif

// MARK: - Additional Functions (get & search)

extension InfoModel {
    
    public func findInfos(byEventID eventID: Int) -> [Info]? {
        let result = infos.filter { $0.eventID == eventID }
        if result.isEmpty {
            return nil
        }
        return result
    }
    
//    public func findInfoID(after info: Info) -> Info? {
//        guard let index = infos.firstIndex(of: info),
//                  infos.indices.contains(index + 1) else {
//            return nil
//        }
//        return infos[index + 1]
//    }
    
    
    
    public func findInfoByID(id: Int) -> Info? {
        let result = infos.filter { $0.id == id }
        if result.isEmpty {
            return nil
        }
        return result.first
    }
    
    public func findLastInfo(byEventId eventID: Int) -> Info? {
        if let result = infos.first(where: { $0.eventID == eventID }) {
            return result
        }
        return nil
    }

}

// MARK: - Additional Functions (move through indexies)

extension InfoModel {
    
//    public func nextInfo(after info: Info) -> Info? {
//        guard let index = infos.firstIndex(of: info),
//                  infos.indices.contains(index + 1) else {
//            return nil
//        }
//        return infos[index + 1]
//    }
//    
//    public func prevInfo(before info: Info) -> Info? {
//        guard let index = infos.firstIndex(of: info),
//                  infos.indices.contains(index - 1) else {
//            return nil
//        }
//        return infos[index - 1]
//    }
    
}

// MARK: - DML SQL functions

extension InfoModel {

    // MARK: - SQL INSERT

    public func sqlINSERT(
        eventId: Int,
        date: Date,
        info: String,
        note: String
    )
    async {

        let sqlQueryINSERT = """
            INSERT INTO
                event.info(
                    event_id,
                    date,
                    info,
                    note
                )
            VALUES (
                    $1,   -- event_id
                    $2,   -- date
                    $3,   -- info
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
                    info,
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
        info: String,
        note: String
    ) async {

        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "217.107.219.91"
            configuration.database = "tercas"
            configuration.user = "postgres"
            configuration.credential = .trust

            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let sqlQueryUPDATE = """
                UPDATE
                    event.vw_info
                SET
                    date = $2,  -- date
                    info = $3,  -- info
                    note = $4   -- note
                WHERE
                    id = $1     -- id
            """
            
            let statement = try connection.prepareStatement(text: sqlQueryUPDATE)
            defer { statement.close() }

            var datePg: PostgresDate {
                return date.postgresDate(in: TimeZone(secondsFromGMT: 0)!)
            }

            let _ = try statement.execute(
                parameterValues: [
                    id,
                    datePg,
                    info,
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
        info: Info
    ) async {

        let sqlQueryUPDATE = """
            UPDATE
                event.vw_info
            SET
                date = $2,  -- date
                info = $3,  -- info
                note = $4   -- note
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

            let statement = try connection.prepareStatement(text: sqlQueryUPDATE)
            defer { statement.close() }

            var datePg: PostgresDate {
                return info.date.postgresDate(in: TimeZone(secondsFromGMT: 0)!)
            }

            let _ = try statement.execute(
                parameterValues: [
                    info.id,
                    datePg,
                    info.info,
                    info.note
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
        id: Int
    ) async {

        let sqlQueryDELETE = """
            DELETE FROM
                event.info
            WHERE
                id = $1  -- id
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
                    id
                ]
            )
        }
        catch {
            print(error)
        }

        await self.reload()
    }
}
