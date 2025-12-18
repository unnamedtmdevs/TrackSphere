import Foundation

class WorkoutService: ObservableObject {
    static let shared = WorkoutService()
    
    private init() {}
    
    // Sample workout templates
    func getWorkoutTemplates() -> [Workout] {
        return [
            Workout(
                name: "Full Body Strength",
                exercises: [
                    Workout.Exercise(name: "Squats", sets: 4, reps: 12, weight: 60, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Bench Press", sets: 4, reps: 10, weight: 50, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Deadlifts", sets: 3, reps: 8, weight: 80, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Pull-ups", sets: 3, reps: 10, weight: nil, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Plank", sets: 3, reps: 1, weight: nil, duration: 60, isCompleted: false)
                ],
                createdAt: Date(),
                isCompleted: false,
                completedAt: nil,
                totalDuration: 3600
            ),
            Workout(
                name: "Cardio Blast",
                exercises: [
                    Workout.Exercise(name: "Running", sets: 1, reps: 1, weight: nil, duration: 1200, isCompleted: false),
                    Workout.Exercise(name: "Jump Rope", sets: 3, reps: 1, weight: nil, duration: 180, isCompleted: false),
                    Workout.Exercise(name: "Burpees", sets: 3, reps: 15, weight: nil, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Mountain Climbers", sets: 3, reps: 20, weight: nil, duration: nil, isCompleted: false)
                ],
                createdAt: Date(),
                isCompleted: false,
                completedAt: nil,
                totalDuration: 2400
            ),
            Workout(
                name: "Upper Body Focus",
                exercises: [
                    Workout.Exercise(name: "Overhead Press", sets: 4, reps: 10, weight: 35, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Dumbbell Rows", sets: 4, reps: 12, weight: 25, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Bicep Curls", sets: 3, reps: 12, weight: 15, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Tricep Dips", sets: 3, reps: 15, weight: nil, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Lateral Raises", sets: 3, reps: 12, weight: 10, duration: nil, isCompleted: false)
                ],
                createdAt: Date(),
                isCompleted: false,
                completedAt: nil,
                totalDuration: 2700
            ),
            Workout(
                name: "Core & Abs",
                exercises: [
                    Workout.Exercise(name: "Crunches", sets: 3, reps: 25, weight: nil, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Russian Twists", sets: 3, reps: 30, weight: 10, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Leg Raises", sets: 3, reps: 15, weight: nil, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Bicycle Crunches", sets: 3, reps: 20, weight: nil, duration: nil, isCompleted: false),
                    Workout.Exercise(name: "Plank Hold", sets: 3, reps: 1, weight: nil, duration: 90, isCompleted: false)
                ],
                createdAt: Date(),
                isCompleted: false,
                completedAt: nil,
                totalDuration: 1800
            )
        ]
    }
    
    func calculateCaloriesBurned(for activity: Activity, userWeight: Double) -> Double {
        // MET (Metabolic Equivalent of Task) values
        let met: Double
        
        switch activity.type {
        case .running:
            met = 9.8
        case .cycling:
            met = 7.5
        case .swimming:
            met = 8.0
        case .walking:
            met = 3.5
        case .gym:
            met = 6.0
        case .yoga:
            met = 2.5
        case .other:
            met = 5.0
        }
        
        // Calories = MET × weight(kg) × time(hours)
        let hours = activity.duration / 3600
        return met * userWeight * hours
    }
    
    func generateSampleActivities() -> [Activity] {
        let calendar = Calendar.current
        var activities: [Activity] = []
        
        // Generate activities for the last 30 days
        for daysAgo in 0..<30 {
            if daysAgo % 2 == 0 { // Every other day
                let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
                
                let activityTypes: [Activity.ActivityType] = [.running, .cycling, .gym, .walking, .yoga]
                let randomType = activityTypes.randomElement() ?? .running
                
                let duration = Double.random(in: 1800...5400) // 30-90 minutes
                let distance = randomType == .running ? Double.random(in: 3...10) :
                              randomType == .cycling ? Double.random(in: 10...30) :
                              randomType == .walking ? Double.random(in: 2...6) : 0
                
                let activity = Activity(
                    type: randomType,
                    duration: duration,
                    distance: distance,
                    calories: Double.random(in: 200...600),
                    date: date,
                    averageHeartRate: Int.random(in: 120...165),
                    notes: nil
                )
                
                activities.append(activity)
            }
        }
        
        return activities.sorted { $0.date > $1.date }
    }
}

