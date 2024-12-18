import SwiftUI

struct ProfileSummary: View {
    @EnvironmentObject var eventModel: EventModel
    var profile: Profile
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(profile.event)
                    .bold()
                    .font(.title)
                
                Text("Notifications: \(profile.prefersNotifications ? "On" : "Off")")
                Text("Phase Photos: \(profile.phasePhoto.rawValue)")
                Text("Goal Date: ") + Text(profile.goalDate, style: .date)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Completed Badges")
                        .font(.headline)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            EventBadge(name: "First Event")
                            EventBadge(name: "Second Event")
                                .foregroundColor(.blue)
                                .hueRotation(Angle(degrees: 90))
                            EventBadge(name: "Third Event")
                                .foregroundColor(.green)
                                .grayscale(0.50)
                                .hueRotation(Angle(degrees: 45))
                        }
                        .padding(.bottom)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Recent Events")
                        .font(.headline)
                    
                    
                }
            }
        }
    }
}

#Preview {
    ProfileSummary(profile: Profile.default)
        .environmentObject(EventModel.example)
}
