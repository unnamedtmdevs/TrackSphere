import Foundation

class DataPersistenceService: ObservableObject {
    static let shared = DataPersistenceService()
    
    private let userProfileKey = "userProfile"
    private let activitiesKey = "activities"
    private let workoutsKey = "workouts"
    
    private init() {}
    
    // MARK: - User Profile
    
    func saveUserProfile(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: userProfileKey)
        }
    }
    
    func loadUserProfile() -> UserProfile? {
        if let data = UserDefaults.standard.data(forKey: userProfileKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            return profile
        }
        return nil
    }
    
    func deleteUserProfile() {
        UserDefaults.standard.removeObject(forKey: userProfileKey)
    }
    
    // MARK: - Activities
    
    func saveActivities(_ activities: [Activity]) {
        if let encoded = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encoded, forKey: activitiesKey)
        }
    }
    
    func loadActivities() -> [Activity] {
        if let data = UserDefaults.standard.data(forKey: activitiesKey),
           let activities = try? JSONDecoder().decode([Activity].self, from: data) {
            return activities
        }
        return []
    }
    
    func addActivity(_ activity: Activity) {
        var activities = loadActivities()
        activities.append(activity)
        saveActivities(activities)
    }
    
    func deleteActivity(_ activity: Activity) {
        var activities = loadActivities()
        activities.removeAll { $0.id == activity.id }
        saveActivities(activities)
    }
    
    func deleteAllActivities() {
        UserDefaults.standard.removeObject(forKey: activitiesKey)
    }
    
    // MARK: - Workouts
    
    func saveWorkouts(_ workouts: [Workout]) {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: workoutsKey)
        }
    }
    
    func loadWorkouts() -> [Workout] {
        if let data = UserDefaults.standard.data(forKey: workoutsKey),
           let workouts = try? JSONDecoder().decode([Workout].self, from: data) {
            return workouts
        }
        return []
    }
    
    func addWorkout(_ workout: Workout) {
        var workouts = loadWorkouts()
        workouts.append(workout)
        saveWorkouts(workouts)
    }
    
    func updateWorkout(_ workout: Workout) {
        var workouts = loadWorkouts()
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
            saveWorkouts(workouts)
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        var workouts = loadWorkouts()
        workouts.removeAll { $0.id == workout.id }
        saveWorkouts(workouts)
    }
    
    func deleteAllWorkouts() {
        UserDefaults.standard.removeObject(forKey: workoutsKey)
    }
    
    // MARK: - Clear All Data
    
    func clearAllData() {
        deleteUserProfile()
        deleteAllActivities()
        deleteAllWorkouts()
    }
}

