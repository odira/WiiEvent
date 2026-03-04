import PostgresClientKit
import SwiftUI
import Combine

public class SubgroupModel: Identifiable, ObservableObject {
    
    @Published public var subgroups = [Subgroup]()
    
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
    
    public init(subgroups: [Subgroup]) {
        self.subgroups = subgroups
    }
    
    public init() {
        self.subgroups.removeAll()
        
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
            
            let sqlText = "SELECT * FROM event.vw_subgroup"
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
                
                let id = try columns[0].int()                //  0
                let subgroup = try columns[1].string()       //  1
                let abbr = try columns[2].string()           //  2
                let description = try? columns[3].string()   //  3
                let note = try? columns[4].string()          //  4
                
                subgroups.append(
                    Subgroup(
                        id: id,
                        subgroup: subgroup,
                        abbr: abbr,
                        description: description,
                        note: note
                    )
                )
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - SubgroupModel example

#if DEBUG
public extension SubgroupModel {
    
    static let subgroupsExamples: [Subgroup] = [
        Subgroup.example,
        Subgroup.example,
        Subgroup.example,
        Subgroup.example,
        Subgroup.example,
        Subgroup.example,
        Subgroup.example,
        Subgroup.example,
        Subgroup.example,
        Subgroup.example,
    ]
    
    static let example = samples[0]
    static let samples: [SubgroupModel] = [
        SubgroupModel(subgroups: subgroupsExamples)
    ]
    
}
#endif
