import SwiftUI

struct WorkoutView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @State private var selectedWorkout: Workout?
    @State private var showingWorkoutDetail = false
    
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
                    Text("Workouts")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    // Active Workouts
                    if !viewModel.activeWorkouts.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Active Plans")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.activeWorkouts) { workout in
                                WorkoutCard(workout: workout) {
                                    selectedWorkout = workout
                                    showingWorkoutDetail = true
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Completed Workouts
                    if !viewModel.completedWorkouts.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Completed")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.completedWorkouts) { workout in
                                WorkoutCard(workout: workout) {
                                    selectedWorkout = workout
                                    showingWorkoutDetail = true
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingWorkoutDetail) {
            if let workout = selectedWorkout {
                WorkoutDetailView(workout: workout, viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.loadWorkouts()
        }
    }
}

struct WorkoutCard: View {
    let workout: Workout
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(workout.name)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("\(workout.exercises.count) exercises")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    if workout.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 28))
                    } else {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.accentBlue)
                            .font(.system(size: 20))
                    }
                }
                
                // Progress bar
                if !workout.isCompleted {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.accentBlue)
                                .frame(width: geometry.size.width * (workout.completionPercentage / 100), height: 8)
                        }
                    }
                    .frame(height: 8)
                    
                    Text("\(Int(workout.completionPercentage))% Complete")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.accentBlue)
                }
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.white.opacity(0.6))
                    Text("\(Int(workout.totalDuration / 60)) min")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding()
            .glassmorphism()
        }
    }
}

struct WorkoutDetailView: View {
    let workout: Workout
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.presentationMode) var presentationMode
    
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
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 28))
                    }
                    
                    Spacer()
                    
                    Text(workout.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.clear)
                        .font(.system(size: 28))
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(workout.exercises) { exercise in
                            ExerciseRow(
                                exercise: exercise,
                                isCompleted: exercise.isCompleted,
                                onToggle: {
                                    viewModel.toggleExerciseCompletion(workout: workout, exercise: exercise)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ExerciseRow: View {
    let exercise: Workout.Exercise
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 15) {
                // Checkbox
                ZStack {
                    Circle()
                        .stroke(isCompleted ? Color.green : Color.accentBlue, lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .strikethrough(isCompleted)
                    
                    Text(exercise.description)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
            }
            .padding()
            .glassmorphism()
        }
    }
}

