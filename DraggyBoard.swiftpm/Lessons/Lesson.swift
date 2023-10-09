import SwiftUI

struct Lesson: Identifiable {
    
    let id = UUID()
    let name: String
    let viewsAllowed: [NodeType]
    let tasks: [LessonTask]
    let introAnimationTree: AppNode
    
    var allTasksAreComplete: Bool {
        // The "Build Your Own App" lesson has zero tasks
        if tasks.isEmpty {
            return false
        }
        for task in tasks {
            if !task.isCompleted {
                return false
            }
        }
        return true
    }
    
    var currentCompletionMessage: String? {
        if tasks.isEmpty {
            return nil
        }
        var mostRecentCompletionString: String? = nil
        var hasSeenAnUncompletedTask = false
        for task in tasks {
            if task.isCompleted {
                if hasSeenAnUncompletedTask {
                    return "Oops! A prior task isn't complete yet..."
                }
                mostRecentCompletionString = task.completionMessage
            } else {
                hasSeenAnUncompletedTask = true
            }
        }
        // If no tasks are complete, return nil so the whole section gets hidden
        return mostRecentCompletionString
    }
    
    init(name: String, viewsAllowed: [NodeType], introAnimationTree: AppNode, tasks: [LessonTask]) {
        self.name = name
        self.viewsAllowed = viewsAllowed
        self.introAnimationTree = introAnimationTree
        self.tasks = tasks
        tasks.first?.isNextTask = true
    }
    
    func checkTaskCompletion(appNode: AppNode) {
        var hasSetNextTask = false
        for t in tasks {
            t.isNextTask = false
            t.checkCompletion(startingFrom: appNode.rootContainerNode)
            if !t.isCompleted && !hasSetNextTask {
                t.isNextTask = true
                hasSetNextTask = true
            }
        }
    }
}
