import Foundation

struct Activity: Codable, Identifiable {
    var id: UUID = UUID()
    var type: ActivityType
    var duration: TimeInterval // in seconds
    var distance: Double // in km
    var calories: Double
    var date: Date
    var averageHeartRate: Int?
    var notes: String?
    
    enum ActivityType: String, Codable, CaseIterable {
        case running = "Running"
        case cycling = "Cycling"
        case swimming = "Swimming"
        case walking = "Walking"
        case gym = "Gym"
        case yoga = "Yoga"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .running: return "figure.run"
            case .cycling: return "bicycle"
            case .swimming: return "figure.pool.swim"
            case .walking: return "figure.walk"
            case .gym: return "dumbbell.fill"
            case .yoga: return "figure.mind.and.body"
            case .other: return "figure.mixed.cardio"
            }
        }
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

