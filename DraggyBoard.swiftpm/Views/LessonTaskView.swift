import SwiftUI

@available(iOS 16, *)
struct LessonTaskView: View {
    
    @ObservedObject var task: LessonTask

    @State private var showImage = false
    private let imageSize = 32.0

    var body: some View {
        HStack {
            if !showImage {
                Image(systemName: "\(task.stepNumber).circle.fill")
                   .resizable()
                   .foregroundColor(.blue)
                   .transition(.move(edge: .leading))
                   .frame(width: imageSize, height: imageSize)
                   .padding(.trailing)
           }
            Text(task.text)
                .opacity(task.isNextTask ? 1.0 : 0.4)
            Spacer()
            if showImage {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .foregroundColor(.green)
                    .bold()
                    .transition(.push(from: .trailing))
                    .frame(width: imageSize, height: imageSize)
                    .padding(.leading)
            }
        }
        .frame(maxWidth: .infinity)
        .onChange(of: task.isCompleted) { newValue in
            withAnimation {
                showImage = task.isCompleted
            }
        }
    }
}

@available(iOS 16, *)
struct LessonTaskView_Previews: PreviewProvider {
    static var previews: some View {
        LessonTaskView(task: LessonTask(text: "Task 1", completionMessage: "Great Job", stepNumber: 1) { _ in
            true
        })
    }
}
