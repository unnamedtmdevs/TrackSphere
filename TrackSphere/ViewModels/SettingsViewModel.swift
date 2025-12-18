import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isEditingProfile = false
    @Published var showDeleteAlert = false
    
    init() {
        loadProfile()
    }
    
    func loadProfile() {
        userProfile = DataPersistenceService.shared.loadUserProfile()
    }
    
    func saveProfile() {
        if let profile = userProfile {
            DataPersistenceService.shared.saveUserProfile(profile)
        }
    }
    
    func deleteAccount(hasCompletedOnboarding: Binding<Bool>) {
        // Clear all data
        DataPersistenceService.shared.clearAllData()
        
        // Reset onboarding
        hasCompletedOnboarding.wrappedValue = false
        
        // Clear user defaults
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    var statisticsSummary: StatsSummary {
        guard let profile = userProfile else {
            return StatsSummary(totalWorkouts: 0, totalDistance: 0, totalCalories: 0, memberSince: Date())
        }
        
        return StatsSummary(
            totalWorkouts: profile.totalWorkouts,
            totalDistance: profile.totalDistance,
            totalCalories: profile.totalCalories,
            memberSince: profile.createdAt
        )
    }
    
    struct StatsSummary {
        let totalWorkouts: Int
        let totalDistance: Double
        let totalCalories: Double
        let memberSince: Date
    }
}

