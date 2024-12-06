import SwiftUI

struct CloudEducationView: View {
    @StateObject private var viewModel = CloudEducationViewModel()
    @State private var selectedSection: CloudEducationContent.EducationSection?
    @State private var showingQuiz = false
    
    var body: some View {
        NavigationView {
            List {
                // Learning Paths
                Section("Learning Paths") {
                    ForEach(viewModel.learningPaths) { path in
                        LearningPathRow(path: path)
                    }
                }
                
                // Quick Lessons
                Section("Quick Lessons") {
                    ForEach(viewModel.quickLessons) { lesson in
                        QuickLessonCard(lesson: lesson)
                    }
                }
                
                // Interactive Tutorials
                Section("Interactive Tutorials") {
                    ForEach(viewModel.tutorials) { tutorial in
                        TutorialCard(tutorial: tutorial)
                    }
                }
            }
            .navigationTitle("Cloud Education")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Quiz Me") {
                        showingQuiz = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingQuiz) {
            QuizView(quiz: viewModel.currentQuiz)
        }
    }
}

struct LearningPathRow: View {
    let path: LearningPath
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(path.title)
                .font(.headline)
            
            ProgressView(value: path.progress)
                .tint(.blue)
            
            HStack {
                Text("\(Int(path.progress * 100))% Complete")
                    .font(.caption)
                Spacer()
                Text("\(path.estimatedTime) min")
                    .font(.caption)
            }
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct QuickLessonCard: View {
    let lesson: QuickLesson
    
    var body: some View {
        VStack {
            Image(lesson.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            
            Text(lesson.title)
                .font(.headline)
            
            Text(lesson.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                ForEach(lesson.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct TutorialCard: View {
    let tutorial: Tutorial
    
    var body: some View {
        HStack {
            Image(systemName: tutorial.icon)
                .font(.title)
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(25)
            
            VStack(alignment: .leading) {
                Text(tutorial.title)
                    .font(.headline)
                Text(tutorial.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
    }
} 