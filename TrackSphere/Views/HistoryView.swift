import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showingFilterSheet = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.primaryBackground, Color.secondaryBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with filter button
                HStack {
                    Text("History")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showingFilterSheet = true
                    }) {
                        Image(systemName: viewModel.filterType == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                            .foregroundColor(.accentBlue)
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))
                    
                    TextField("Search activities...", text: $viewModel.searchText)
                        .foregroundColor(.white)
                        .font(.system(size: 17, design: .rounded))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
                .padding(.horizontal)
                .padding(.bottom, 15)
                
                // Personal Bests
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        PersonalBestCard(
                            title: "Longest Run",
                            value: String(format: "%.1f km", viewModel.personalBests.longestDistance),
                            icon: "location.fill",
                            color: .green
                        )
                        
                        PersonalBestCard(
                            title: "Most Calories",
                            value: String(format: "%.0f", viewModel.personalBests.mostCalories),
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        PersonalBestCard(
                            title: "Longest Time",
                            value: formatDuration(viewModel.personalBests.longestDuration),
                            icon: "clock.fill",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 15)
                
                // Activities list
                if viewModel.filteredActivities.isEmpty {
                    Spacer()
                    
                    VStack(spacing: 15) {
                        Image(systemName: "tray.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("No activities found")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(Array(viewModel.groupedActivities.keys.sorted(by: >)), id: \.self) { dateKey in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(dateKey)
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(.horizontal)
                                    
                                    ForEach(viewModel.groupedActivities[dateKey] ?? []) { activity in
                                        ActivityCard(activity: activity) {
                                            viewModel.deleteActivity(activity)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheet(selectedType: $viewModel.filterType)
        }
        .onAppear {
            viewModel.loadActivities()
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct ActivityCard: View {
    let activity: Activity
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.accentBlue.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: activity.type.icon)
                    .foregroundColor(.accentBlue)
                    .font(.system(size: 24))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.type.rawValue)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                HStack(spacing: 15) {
                    if activity.distance > 0 {
                        Label(String(format: "%.1f km", activity.distance), systemImage: "location.fill")
                    }
                    
                    Label(activity.formattedDuration, systemImage: "clock.fill")
                    
                    Label(String(format: "%.0f cal", activity.calories), systemImage: "flame.fill")
                }
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red.opacity(0.8))
                    .font(.system(size: 18))
            }
        }
        .padding()
        .glassmorphism()
    }
}

struct PersonalBestCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .frame(width: 150)
        .glassmorphism()
    }
}

struct FilterSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedType: Activity.ActivityType?
    
    var body: some View {
        ZStack {
            Color.secondaryBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Filter by Activity Type")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                VStack(spacing: 12) {
                    // All option
                    Button(action: {
                        selectedType = nil
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "square.grid.2x2.fill")
                                .foregroundColor(.accentBlue)
                                .font(.system(size: 24))
                            
                            Text("All Activities")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if selectedType == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentBlue)
                            }
                        }
                        .padding()
                        .glassmorphism()
                    }
                    
                    ForEach(Activity.ActivityType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedType = type
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundColor(.accentBlue)
                                    .font(.system(size: 24))
                                
                                Text(type.rawValue)
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if selectedType == type {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentBlue)
                                }
                            }
                            .padding()
                            .glassmorphism()
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

