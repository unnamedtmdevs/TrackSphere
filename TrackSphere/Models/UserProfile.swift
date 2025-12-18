import Foundation

struct UserProfile: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var age: Int
    var weight: Double // in kg
    var height: Double // in cm
    var fitnessGoal: FitnessGoal
    var weeklyGoal: Int // workouts per week
    var createdAt: Date
    var totalWorkouts: Int
    var totalDistance: Double // in km
    var totalCalories: Double
    
    enum FitnessGoal: String, Codable, CaseIterable {
        case loseWeight = "Lose Weight"
        case buildMuscle = "Build Muscle"
        case stayActive = "Stay Active"
        case improveEndurance = "Improve Endurance"
    }
    
    static var `default`: UserProfile {
        UserProfile(
            name: "",
            age: 25,
            weight: 70.0,
            height: 175.0,
            fitnessGoal: .stayActive,
            weeklyGoal: 3,
            createdAt: Date(),
            totalWorkouts: 0,
            totalDistance: 0,
            totalCalories: 0
        )
    }
}

