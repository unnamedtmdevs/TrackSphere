import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.primaryBackground, Color.secondaryBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    Text("Settings")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    // Profile section
                    if let profile = viewModel.userProfile {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Profile")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                ProfileRow(icon: "person.fill", title: "Name", value: profile.name)
                                ProfileRow(icon: "target", title: "Goal", value: profile.fitnessGoal.rawValue)
                                ProfileRow(icon: "calendar", title: "Weekly Target", value: "\(profile.weeklyGoal) workouts")
                            }
                        }
                        .padding()
                        .glassmorphism()
                        .padding(.horizontal)
                    }
                    
                    // Statistics summary
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Your Progress")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 12) {
                            StatRow(
                                icon: "figure.run",
                                title: "Total Workouts",
                                value: "\(viewModel.statisticsSummary.totalWorkouts)",
                                color: .accentBlue
                            )
                            
                            StatRow(
                                icon: "location.fill",
                                title: "Total Distance",
                                value: String(format: "%.1f km", viewModel.statisticsSummary.totalDistance),
                                color: .green
                            )
                            
                            StatRow(
                                icon: "flame.fill",
                                title: "Total Calories",
                                value: String(format: "%.0f", viewModel.statisticsSummary.totalCalories),
                                color: .orange
                            )
                            
                            Divider()
                                .background(Color.white.opacity(0.2))
                            
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundColor(.purple)
                                    .font(.system(size: 20))
                                
                                Text("Member since")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Spacer()
                                
                                Text(formatDate(viewModel.statisticsSummary.memberSince))
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    .glassmorphism()
                    .padding(.horizontal)
                    
                    // Danger zone
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Danger Zone")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.red)
                        
                        Button(action: {
                            viewModel.showDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                                
                                Text("Delete Account")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .foregroundColor(.red)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.red)
                                    .font(.system(size: 14))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.red.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding()
                    .glassmorphism()
                    .padding(.horizontal)
                    
                    // App info
                    VStack(spacing: 8) {
                        Text("TrackSphere")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Version 1.0.0")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 100)
                }
                .padding(.bottom, 20)
            }
        }
        .alert(isPresented: $viewModel.showDeleteAlert) {
            Alert(
                title: Text("Delete Account"),
                message: Text("This will permanently delete all your data and reset the app. This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteAccount(hasCompletedOnboarding: $hasCompletedOnboarding)
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            viewModel.loadProfile()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentBlue)
                .font(.system(size: 20))
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 20))
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

