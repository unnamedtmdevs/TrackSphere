//
//  ContentView.swift
//  TrackSphere
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedTab = 0
    
    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        } else {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.primaryBackground, Color.secondaryBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Main content
                    TabView(selection: $selectedTab) {
                        StatisticsView()
                            .tag(0)
                        
                        WorkoutView()
                            .tag(1)
                        
                        HistoryView()
                            .tag(2)
                        
                        SettingsView()
                            .tag(3)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Custom tab bar
                    CustomTabBar(selectedTab: $selectedTab)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(icon: "chart.line.uptrend.xyaxis", title: "Stats"),
        TabItem(icon: "dumbbell.fill", title: "Workout"),
        TabItem(icon: "clock.fill", title: "History"),
        TabItem(icon: "gearshape.fill", title: "Settings")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: tabs[index].icon)
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == index ? .accentBlue : .white.opacity(0.5))
                        
                        Text(tabs[index].title)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(selectedTab == index ? .accentBlue : .white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}

struct TabItem {
    let icon: String
    let title: String
}

#Preview {
    ContentView()
}
