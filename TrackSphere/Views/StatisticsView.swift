import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
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
                    Text("Statistics")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    // Time range selector
                    Picker("Range", selection: $viewModel.selectedTimeRange) {
                        ForEach(StatisticsViewModel.TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .colorScheme(.dark)
                    .padding(.horizontal)
                    .onChange(of: viewModel.selectedTimeRange) { _ in
                        viewModel.loadData()
                    }
                    
                    // Stats grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatCard(
                            title: "Workouts",
                            value: "\(viewModel.totalWorkouts)",
                            icon: "figure.run",
                            color: .accentBlue
                        )
                        
                        StatCard(
                            title: "Distance",
                            value: String(format: "%.1f km", viewModel.totalDistance),
                            icon: "location.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Calories",
                            value: String(format: "%.0f", viewModel.totalCalories),
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Avg HR",
                            value: "\(viewModel.averageHeartRate) bpm",
                            icon: "heart.fill",
                            color: .red
                        )
                    }
                    .padding(.horizontal)
                    
                    // Weekly progress chart
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Weekly Activity")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        HStack(alignment: .bottom, spacing: 12) {
                            ForEach(viewModel.weeklyProgress) { data in
                                VStack(spacing: 8) {
                                    // Bar
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.accentBlue, Color.accentBlue.opacity(0.6)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(height: max(20, CGFloat(data.minutes) * 2))
                                    
                                    // Day label
                                    Text(data.day)
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding()
                    .glassmorphism()
                    .padding(.horizontal)
                    
                    // Total duration
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.accentBlue)
                            .font(.system(size: 24))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Total Time")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text(formatDuration(viewModel.totalDuration))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .glassmorphism()
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            viewModel.loadData()
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

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 24))
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassmorphism()
    }
}

