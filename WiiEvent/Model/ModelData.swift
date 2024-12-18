import Foundation
//import SwiftUI

@Observable
class ModelData {
//    var events: [Event] = EventModel.events
    
//    var categories: [String: [Event]] {
//        Dictionary(
//            grouping: events,
//            by: { $0.category.rawValue }
//        )
//    }
    
    var profile = Profile.default
}

//var events: [Event] = load("eventData.json")
//
//func load<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//    
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//    else {
//        fatalError("Couldn't find \(filename) in main bundle.")
//    }
//    
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//    
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}
