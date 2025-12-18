import Foundation

struct Workout: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var exercises: [Exercise]
    var createdAt: Date
    var isCompleted: Bool
    var completedAt: Date?
    var totalDuration: TimeInterval
    
    struct Exercise: Codable, Identifiable {
        var id: UUID = UUID()
        var name: String
        var sets: Int
        var reps: Int
        var weight: Double? // in kg
        var duration: TimeInterval? // for time-based exercises
        var isCompleted: Bool
        
        var description: String {
            if let duration = duration {
                let minutes = Int(duration) / 60
                return "\(minutes) min"
            } else if let weight = weight {
                return "\(sets) × \(reps) @ \(String(format: "%.1f", weight))kg"
            } else {
                return "\(sets) × \(reps)"
            }
        }
    }
    
    var completionPercentage: Double {
        guard !exercises.isEmpty else { return 0 }
        let completed = exercises.filter { $0.isCompleted }.count
        return Double(completed) / Double(exercises.count) * 100
    }
}

