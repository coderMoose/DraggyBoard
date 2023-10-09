import SwiftUI

class LessonTask: Identifiable, ObservableObject {

    let id = UUID()
    let text: String
    let completionMessage: String
    let stepNumber: Int
    private let checkCompletion: (ContainerNode) -> Bool

    @Published var isCompleted = false
    @Published var isNextTask = false
    
    init(text: String, completionMessage: String, stepNumber: Int, checkCompletion: @escaping (ContainerNode) -> Bool) {
        self.text = text
        self.completionMessage = completionMessage
        self.stepNumber = stepNumber
        self.checkCompletion = checkCompletion
    }
    
    func checkCompletion(startingFrom rootNode: ContainerNode) {
        withAnimation {
            isCompleted = checkCompletion(rootNode)
        }
    }
}
