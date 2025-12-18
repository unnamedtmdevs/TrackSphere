import Foundation
import SwiftUI

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var selectedWorkout: Workout?
    @Published var isCreatingWorkout = false
    
    init() {
        loadWorkouts()
    }
    
    func loadWorkouts() {
        workouts = DataPersistenceService.shared.loadWorkouts()
        
        // Add templates if no workouts exist
        if workouts.isEmpty {
            let templates = WorkoutService.shared.getWorkoutTemplates()
            templates.forEach { addWorkout($0) }
        }
    }
    
    func addWorkout(_ workout: Workout) {
        DataPersistenceService.shared.addWorkout(workout)
        loadWorkouts()
    }
    
    func updateWorkout(_ workout: Workout) {
        DataPersistenceService.shared.updateWorkout(workout)
        loadWorkouts()
    }
    
    func deleteWorkout(_ workout: Workout) {
        DataPersistenceService.shared.deleteWorkout(workout)
        loadWorkouts()
    }
    
    func toggleExerciseCompletion(workout: Workout, exercise: Workout.Exercise) {
        var updatedWorkout = workout
        if let index = updatedWorkout.exercises.firstIndex(where: { $0.id == exercise.id }) {
            updatedWorkout.exercises[index].isCompleted.toggle()
            
            // Check if all exercises are completed
            let allCompleted = updatedWorkout.exercises.allSatisfy { $0.isCompleted }
            if allCompleted && !updatedWorkout.isCompleted {
                updatedWorkout.isCompleted = true
                updatedWorkout.completedAt = Date()
                
                // Convert workout to activity
                createActivityFromWorkout(updatedWorkout)
            }
            
            updateWorkout(updatedWorkout)
        }
    }
    
    private func createActivityFromWorkout(_ workout: Workout) {
        let activity = Activity(
            type: .gym,
            duration: workout.totalDuration,
            distance: 0,
            calories: calculateCalories(for: workout),
            date: Date(),
            averageHeartRate: 135,
            notes: "Completed: \(workout.name)"
        )
        
        DataPersistenceService.shared.addActivity(activity)
        
        // Update user profile stats
        if var profile = DataPersistenceService.shared.loadUserProfile() {
            profile.totalWorkouts += 1
            profile.totalCalories += activity.calories
            DataPersistenceService.shared.saveUserProfile(profile)
        }
    }
    
    private func calculateCalories(for workout: Workout) -> Double {
        // Rough estimation: 5 calories per minute of workout
        return (workout.totalDuration / 60) * 5
    }
    
    var activeWorkouts: [Workout] {
        workouts.filter { !$0.isCompleted }
    }
    
    var completedWorkouts: [Workout] {
        workouts.filter { $0.isCompleted }
    }
}

