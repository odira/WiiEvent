import SwiftUI

struct CategoryHome: View {
    
//    @EnvironmentObject var appState: AppState
    @EnvironmentObject var eventModel: EventModel
    
    @State private var showingProfile = false
    
    var body: some View {
        
        List {
//            eventModel.optionalOnes[0].image
//                .resizable()
//                .scaledToFill()
//                .frame(height: 200)
//                .clipped()
//                .listRowInsets(EdgeInsets())
            
            ForEach(eventModel.categories.keys.sorted(), id: \.self) { key in
                CategoryRow(categoryName: key, items: eventModel.categories[key]!)
            }
//            .listRowInsets(EdgeInsets())
        }
        .listStyle(.inset)
        
        .toolbar {
            Button {
                showingProfile.toggle()
            } label: {
                Label("User Profile", systemImage: "person.crop.circle")
            }
        }
        
        .sheet(isPresented: $showingProfile) {
            ProfileHost()
                .environmentObject(eventModel)
        }

//        .navigationViewStyle(.stack)
    } // body
}

#Preview {
    CategoryHome()
        .environmentObject(EventModel.example)
//        .environmentObject(AppState())
}
