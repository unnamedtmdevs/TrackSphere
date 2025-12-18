import Foundation
import SwiftUI

class StatisticsViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var userProfile: UserProfile?
    @Published var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        let persistence = DataPersistenceService.shared
        activities = persistence.loadActivities()
        userProfile = persistence.loadUserProfile()
    }
    
    var filteredActivities: [Activity] {
        let calendar = Calendar.current
        let now = Date()
        
        return activities.filter { activity in
            switch selectedTimeRange {
            case .week:
                return calendar.isDate(activity.date, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return calendar.isDate(activity.date, equalTo: now, toGranularity: .month)
            case .year:
                return calendar.isDate(activity.date, equalTo: now, toGranularity: .year)
            case .all:
                return true
            }
        }
    }
    
    var totalWorkouts: Int {
        filteredActivities.count
    }
    
    var totalDistance: Double {
        filteredActivities.reduce(0) { $0 + $1.distance }
    }
    
    var totalCalories: Double {
        filteredActivities.reduce(0) { $0 + $1.calories }
    }
    
    var totalDuration: TimeInterval {
        filteredActivities.reduce(0) { $0 + $1.duration }
    }
    
    var averageHeartRate: Int {
        let rates = filteredActivities.compactMap { $0.averageHeartRate }
        guard !rates.isEmpty else { return 0 }
        return rates.reduce(0, +) / rates.count
    }
    
    var weeklyProgress: [DayData] {
        let calendar = Calendar.current
        let today = Date()
        var dayData: [DayData] = []
        
        for dayOffset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) ?? today
            let dayActivities = activities.filter { calendar.isDate($0.date, inSameDayAs: date) }
            let totalMinutes = dayActivities.reduce(0.0) { $0 + $1.duration } / 60
            
            let weekday = calendar.component(.weekday, from: date)
            let dayName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][weekday - 1]
            
            dayData.append(DayData(day: dayName, minutes: totalMinutes, date: date))
        }
        
        return dayData.reversed()
    }
    
    struct DayData: Identifiable {
        let id = UUID()
        let day: String
        let minutes: Double
        let date: Date
    }
}

