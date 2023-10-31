import Foundation

class LessonManager {
    static var allLessons = [firstLesson, secondLesson, thirdLesson, fourthLesson, fifthLesson, sixthLesson]
    
    static var buildYourOwnAppLesson: Lesson {
        Lesson(name: "Build Your Own App",
               viewsAllowed: NodeType.draggableTypes,
               introAnimationTree:
                   AppNode(rootNode:
                       VStackNode(subNodes: [
                           TextNode(displayText: "Time to dream"),
                           SystemImageNode(systemImageName: "sun.max.fill", imageColor: .orange),
                           TextNode(displayText: "Build"),
                           TextNode(displayText: "your own app!"),
                           SpacerNode(),
                           TextNode(displayText: "Anything"),
                           TextNode(displayText: "you want"),
                           SpacerNode(),
                           TextNode(displayText: "Have Fun!")
                       ])
                   ),
               tasks: [])
    }
    static var buildYourOwnChartLesson: Lesson {
        Lesson(name: "Build Your Own Chart",
               viewsAllowed: [.chart, .barMark],
               introAnimationTree:
                   AppNode(rootNode:
                       VStackNode(subNodes: [
                           TextNode(displayText: "Charts"),
                           // ...
                       ])
                   ),
               tasks: [
                   LessonTask(text: "Add a chart", completionMessage: "Nice!", stepNumber: 1) {
                       $0.chartNodes.count >= 1
                   }
               ])
    }
}

private let firstLesson = Lesson(
    name: "1. VStacks",
    viewsAllowed: [.text, .hStack],
    introAnimationTree: buildFirstLessonIntro(),
    tasks: [
        LessonTask(text: "Drag a Text View on to the VStack above.", completionMessage: "Nice work!", stepNumber: 1) {
            $0.textNodes.count >= 1
        },
        LessonTask(text: "Drag a second Text View on to the VStack.", completionMessage: "V means vertical - see how it's below the other one?", stepNumber: 2) {
            $0.textNodes.count >= 2
        },
        LessonTask(text: "Now drag an HStack on to the VStack.", completionMessage: "H means horizontal - ready to go sideways?", stepNumber: 3) {
            $0.hStackNodes.count >= 1
        },
        LessonTask(text: "Drag a Text View on to the HStack (*not* on to the VStack).", completionMessage: "Great, now we need one more beside it", stepNumber: 4) {
            ($0.hStackNodes.first?.textNodes.count ?? 0) >= 1
        },
        LessonTask(text: "Drag a second Text View on to the HStack (*not* on to the VStack).", completionMessage: "Awesome! See how they're side by side?", stepNumber: 5) {
            ($0.hStackNodes.first?.textNodes.count ?? 0) >= 2
        }
    ]
)

private let secondLesson = Lesson(
    name: "2. Spacers",
    viewsAllowed: [.text, .hStack, .vStack, .spacer, .image],
    introAnimationTree: buildSecondLessonIntro(),
    tasks: [
        LessonTask(text: "Drag a Text View on to the VStack above.", completionMessage: "Nice work! Now let's space things out a bit...", stepNumber: 1) {
            $0.textNodes.count >= 1
        },
        LessonTask(text: "Drag a Spacer on to the VStack.", completionMessage: "See how it slid to the top? The Spacer ate up space", stepNumber: 2) {
            $0.spacerNodes.count >= 1
        },
        LessonTask(text: "Now drag an HStack on to the VStack.", completionMessage: "Time to go sideways...", stepNumber: 3) {
            $0.hStackNodes.count >= 1
        },
        LessonTask(text: "Now drag an Image View on to the HStack (*not* the VStack).", completionMessage: "Now let's push it to the side...", stepNumber: 4) {
            ($0.hStackNodes.first?.imageNodes ?? []).count >= 1
        },
        LessonTask(text: "Now drag a Spacer on to the HStack (*not* the VStack).", completionMessage: "See how it slid to the side? The magic of Spacer", stepNumber: 5) {
            ($0.hStackNodes.first?.spacerNodes ?? []).count >= 1
        },
        LessonTask(text: "Now drag a second Spacer on to the VStack (*not* the HStack).", completionMessage: "See how the HStack moved up? The two Spacers are sharing the free space", stepNumber: 6) {
            $0.spacerNodes.count >= 2
        }
    ]
)

private let thirdLesson = Lesson(
    name: "3. Images",
    viewsAllowed: [.image],
    introAnimationTree: buildThirdLessonIntro(),
    tasks: [
        LessonTask(text: "Drag an Image View on to the VStack above.", completionMessage: "Nice work!", stepNumber: 1) {
            $0.imageNodes.count >= 1
        },
        LessonTask(text: "Now select the image, and make its size bigger.", completionMessage: "Much better, it's easier to see now.", stepNumber: 2) {
            $0.imageNodes.count >= 1 && $0.imageNodes.first!.imageSizeModification.imageSize > 20
        },
        LessonTask(text: "Now change the Image's color.", completionMessage: "Awesome! You can also tap 'Pick Image' to change the image itself", stepNumber: 3) {
            $0.imageNodes.count >= 1 && $0.imageNodes.first!.imageColorModification.imageColor != .primary
        }
    ]
)

private let fourthLesson = Lesson(
    name: "4. Text",
    viewsAllowed: [.text],
    introAnimationTree: buildFourthLessonIntro(),
    tasks: [
        LessonTask(text: "Drag a Text View on to the VStack above.", completionMessage: "Nice work!", stepNumber: 1) {
            $0.textNodes.count >= 1
        },
        LessonTask(text: "Now change the text to say 'Welcome!'", completionMessage: "Looks great!", stepNumber: 2) {
            if let textNode = $0.textNodes.first {
                return textNode.displayText.lowercased().contains("welcome")
            }
            return false
        },
        LessonTask(text: "Now change the Text's color.", completionMessage: "Awesome! You can also change the size of the text", stepNumber: 3) {
            $0.textNodes.count >= 1 && $0.textNodes.first!.textColorModification.textColor != .primary
        },
        LessonTask(text: "Now make the Text bold.", completionMessage: "Great work!", stepNumber: 4) {
            $0.textNodes.count >= 1 && $0.textNodes.first!.textBoldModification.isBold
        }
    ]
)

private let fifthLesson = Lesson(
    name: "5. Buttons",
    viewsAllowed: [.image, .hStack, .button, .text],
    introAnimationTree: buildFifthLessonIntro(),
    tasks: [
        LessonTask(text: "Drag a Button View on to the VStack above.", completionMessage: "Nice! See how it highlights when you click it in the Preview?", stepNumber: 1) {
            $0.buttonNodes.count >= 1
        },
        LessonTask(text: "Find the Button's Text View. Change the text to 'Go'.", completionMessage: "Buttons can contain multiple views. All of them are tappable", stepNumber: 2) {
            if let textNode = $0.buttonNodes.first?.hStackNodes.first?.textNodes.first {
                return textNode.displayText.lowercased().contains("go")
            }
            return false
        },
        LessonTask(text: "Now drag an Image View on to the HStack (*not* the VStack).", completionMessage: "Nice work! See how the button has two images?", stepNumber: 3) {
            ($0.buttonNodes.first?.hStackNodes.first?.imageNodes ?? []).count >= 2
        },
        LessonTask(text: "Now make one of the images bigger.", completionMessage: "Nice - the button will grow as its contents grow!", stepNumber: 4) {
            ($0.buttonNodes.first?.hStackNodes.first?.imageNodes ?? []).contains { imageNode in
                imageNode.imageSizeModification.imageSize > 20
            }
        }
    ]
)

private let sixthLesson = Lesson(
    name: "6. Lists",
    viewsAllowed: [.list, .text],
    introAnimationTree: buildSixthLessonIntro(),
    tasks: [
        LessonTask(text: "Drag a List View on to the VStack above.", completionMessage: "Nice! Looks like we've got some items already there", stepNumber: 1) {
            $0.listNodes.count >= 1
        },
        LessonTask(text: "Now drag a Text View on to the List.", completionMessage: "Great! Now we have 5 items!", stepNumber: 2) {
            $0.listNodes.count >= 1 && $0.listNodes.first!.textNodes.count == 5
        },
        LessonTask(text: "Use 'Move Up' to make your new 'Hello World' item the first one in the list", completionMessage: "Awesome job!", stepNumber: 3) {
            $0.listNodes.count >= 1 && $0.listNodes.first!.textNodes.first?.displayText == "Hello World"
        }
    ]
)

private func buildFirstLessonIntro() -> AppNode {
    AppNode(rootNode:
        VStackNode(subNodes: [
            TextNode(displayText: "VStacks", isBold: true),
            TextNode(displayText: "allow you to"),
            TextNode(displayText: "stack items"),
            TextNode(displayText: "vertically"),
            SystemImageNode(systemImageName: "arrow.up.arrow.down", imageColor: .blue),
            TextNode(displayText: "One"),
            TextNode(displayText: "on top"),
            TextNode(displayText: "of the other"),
            SpacerNode(),
            TextNode(displayText: "Give it a try!"),
        ])
    )
}

private func buildSecondLessonIntro() -> AppNode {
    AppNode(rootNode:
        VStackNode(subNodes: [
            TextNode(displayText: "Spacers", isBold: true),
            TextNode(displayText: "are used"),
            SpacerNode(),
            TextNode(displayText: "to spread"),
            TextNode(displayText: "things out"),
            SpacerNode(),
            TextNode(displayText: "vertically"),
            TextNode(displayText: "or"),
            TextNode(displayText: "horizontally"),
        ])
    )
}

private func buildThirdLessonIntro() -> AppNode {
    AppNode(rootNode:
        VStackNode(subNodes: [
            TextNode(displayText: "Images", isBold: true),
            SystemImageNode(systemImageName: "camera", imageColor: .blue, imageSize: 50),
            SpacerNode(),
            TextNode(displayText: "bring your"),
            TextNode(displayText: "app to life"),
            SpacerNode(),
            HStackNode(subNodes: [
                SystemImageNode(systemImageName: "clock", imageColor: .red),
                SystemImageNode(systemImageName: "wifi", imageColor: .gray),
                SystemImageNode(systemImageName: "message", imageColor: .green),
            ])
        ])
    )
}

private func buildFourthLessonIntro() -> AppNode {
    AppNode(rootNode:
        VStackNode(subNodes: [
            TextNode(displayText: "Text"),
            SpacerNode(),
            TextNode(displayText: "can be"),
            TextNode(displayText: "bold", isBold: true),
            SpacerNode(),
            TextNode(displayText: "big", textSize: .largeTitle),
            TextNode(displayText: "small", textSize: .caption),
            SpacerNode(),
            TextNode(displayText: "and colorful", textColor: .blue),
        ])
    )
}

private func buildFifthLessonIntro() -> AppNode {
    let textNode = TextNode(displayText: "Tap me!", textColor: .blue)
    let buttonNode = ButtonNode(subNodes: [textNode], disableAction: true)
    textNode.parentNode = buttonNode
    return AppNode(rootNode:
        VStackNode(subNodes: [
            TextNode(displayText: "Buttons", isBold: true),
            SpacerNode(),
            TextNode(displayText: "give powers"),
            TextNode(displayText: "to views"),
            TextNode(displayText: "like Text"),
            TextNode(displayText: "and Image"),
            SpacerNode(),
            buttonNode,
            SpacerNode(),
            TextNode(displayText: "making them"),
            TextNode(displayText: "tappable!", isBold: true),
        ])
    )
}

private func buildSixthLessonIntro() -> AppNode {
    AppNode(rootNode:
        VStackNode(subNodes: [
            TextNode(displayText: "Lists", isBold: true),
            ContainerNode.makeList(),
            TextNode(displayText: "make scrolling"),
            TextNode(displayText: "super easy!", isBold: true),
        ])
    )
}
