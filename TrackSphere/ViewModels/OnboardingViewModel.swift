import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var userProfile = UserProfile.default
    
    let pages = [
        OnboardingPage(
            title: "Track Your Progress",
            description: "Monitor your workouts, activities, and achievements in real-time with detailed statistics",
            icon: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Custom Workouts",
            description: "Create personalized workout plans tailored to your fitness goals and track your progress",
            icon: "dumbbell.fill"
        ),
        OnboardingPage(
            title: "Stay Motivated",
            description: "Track your achievements and reach your fitness goals with detailed insights and progress tracking",
            icon: "trophy.fill"
        )
    ]
    
    func completeOnboarding() {
        let persistence = DataPersistenceService.shared
        userProfile.createdAt = Date()
        persistence.saveUserProfile(userProfile)
        
        // Generate sample data for demo purposes
        let sampleActivities = WorkoutService.shared.generateSampleActivities()
        persistence.saveActivities(sampleActivities)
    }
    
    struct OnboardingPage {
        let title: String
        let description: String
        let icon: String
    }
}

