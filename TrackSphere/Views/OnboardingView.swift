import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.primaryBackground, Color.secondaryBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentPage ? Color.accentBlue : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: viewModel.currentPage)
                    }
                }
                .padding(.top, 50)
                
                // Content
                TabView(selection: $viewModel.currentPage) {
                    ForEach(0..<viewModel.pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            Spacer()
                            
                            // Icon
                            Image(systemName: viewModel.pages[index].icon)
                                .font(.system(size: 100))
                                .foregroundColor(.accentBlue)
                            
                            // Title
                            Text(viewModel.pages[index].title)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            // Description
                            Text(viewModel.pages[index].description)
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Profile setup (last page)
                if viewModel.currentPage == viewModel.pages.count - 1 {
                    profileSetupSection
                }
                
                // Bottom buttons
                VStack(spacing: 15) {
                    if viewModel.currentPage < viewModel.pages.count - 1 {
                        Button(action: {
                            withAnimation {
                                viewModel.currentPage += 1
                            }
                        }) {
                            Text("Continue")
                        }
                        .buttonStyle(GlassButtonStyle())
                        .padding(.horizontal, 40)
                    } else {
                        Button(action: {
                            viewModel.completeOnboarding()
                            hasCompletedOnboarding = true
                        }) {
                            Text("Get Started")
                        }
                        .buttonStyle(GlassButtonStyle())
                        .padding(.horizontal, 40)
                        .disabled(viewModel.userProfile.name.isEmpty)
                        .opacity(viewModel.userProfile.name.isEmpty ? 0.5 : 1.0)
                    }
                    
                    if viewModel.currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                viewModel.currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private var profileSetupSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Your Name")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                
                TextField("Enter your name", text: $viewModel.userProfile.name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .foregroundColor(.white)
                    .font(.system(size: 17, design: .rounded))
                
                // Fitness Goal
                Text("Fitness Goal")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                
                Picker("Goal", selection: $viewModel.userProfile.fitnessGoal) {
                    ForEach(UserProfile.FitnessGoal.allCases, id: \.self) { goal in
                        Text(goal.rawValue).tag(goal)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .colorScheme(.dark)
            }
            .padding(.horizontal, 40)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

