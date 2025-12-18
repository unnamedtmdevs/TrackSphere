import Foundation
import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var selectedActivity: Activity?
    @Published var filterType: Activity.ActivityType?
    @Published var searchText = ""
    
    init() {
        loadActivities()
    }
    
    func loadActivities() {
        activities = DataPersistenceService.shared.loadActivities()
    }
    
    func deleteActivity(_ activity: Activity) {
        DataPersistenceService.shared.deleteActivity(activity)
        loadActivities()
        
        // Update user profile stats
        if var profile = DataPersistenceService.shared.loadUserProfile() {
            profile.totalWorkouts = max(0, profile.totalWorkouts - 1)
            profile.totalDistance = max(0, profile.totalDistance - activity.distance)
            profile.totalCalories = max(0, profile.totalCalories - activity.calories)
            DataPersistenceService.shared.saveUserProfile(profile)
        }
    }
    
    var filteredActivities: [Activity] {
        var filtered = activities
        
        // Filter by type
        if let filterType = filterType {
            filtered = filtered.filter { $0.type == filterType }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
                ($0.notes?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    var groupedActivities: [String: [Activity]] {
        let calendar = Calendar.current
        var grouped: [String: [Activity]] = [:]
        
        for activity in filteredActivities {
            let components = calendar.dateComponents([.year, .month, .day], from: activity.date)
            if let date = calendar.date(from: components) {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                let key = formatter.string(from: date)
                
                if grouped[key] != nil {
                    grouped[key]?.append(activity)
                } else {
                    grouped[key] = [activity]
                }
            }
        }
        
        return grouped
    }
    
    var personalBests: PersonalBests {
        guard !activities.isEmpty else {
            return PersonalBests(longestDistance: 0, mostCalories: 0, longestDuration: 0)
        }
        
        let longestDistance = activities.max(by: { $0.distance < $1.distance })?.distance ?? 0
        let mostCalories = activities.max(by: { $0.calories < $1.calories })?.calories ?? 0
        let longestDuration = activities.max(by: { $0.duration < $1.duration })?.duration ?? 0
        
        return PersonalBests(
            longestDistance: longestDistance,
            mostCalories: mostCalories,
            longestDuration: longestDuration
        )
    }
    
    struct PersonalBests {
        let longestDistance: Double
        let mostCalories: Double
        let longestDuration: TimeInterval
    }
}

