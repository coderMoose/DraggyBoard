import Foundation

enum NodeType: String, CaseIterable {
    case app
    case text
    case image
    case button
    case hStack
    case vStack
    case zStack
    case spacer
    case picker
    case list
    
    var capitalizedName: String {
        switch self {
        case .app:
            return "App"
        case .text:
            return "Text"
        case .image:
            return "Image"
        case .button:
            return "Button"
        case .hStack:
            return "HStack"
        case .vStack:
            return "VStack"
        case .zStack:
            return "ZStack"
        case .spacer:
            return "Spacer"
        case .picker:
            return "Picker"
        case .list:
            return "List"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .app:
            return ""
        case .text:
            return "text.alignleft"
        case .image:
            return "photo"
        case .button:
            return "hand.tap"
        case .hStack:
            return "arrow.left.arrow.right"
        case .vStack:
            return "arrow.up.arrow.down"
        case .zStack:
            return "rectangle.stack"
        case .spacer:
            return "space"
        case .picker:
            return "list.bullet"
        case .list:
            return "list.clipboard"
        }
    }
    
    var explanation: String {
        switch self {
        case .app:
            return ""
        case .text:
            return "This allows you to write text on the screen. You can use modifiers like .font(), .foregroundColor, and .bold() to control how it looks on the screen."
        case .image:
            return "This allows you to show images on the screen. You can use systemName to pick from existing images that SwiftUI provides, or you can pick from images you provide yourself."
        case .button:
            return "This allows you to detect when the user taps on something. You can use this to make anything tappable - for example, a Button can contain Text/Image/HStack etc..."
        case .hStack:
            return "An HStack is something that enables you to arrange items in a horizontal row, each one beside the other."
        case .vStack:
            return "A VStack is something that enables you to arrange items in a vertical row, each one below the other."
        case .zStack:
            return "A ZStack is something that enables you to stack items, each one on top of the other."
        case .spacer:
            return "A Spacer is invisible, but it forces the views next to it to move away as far as they can. For example, you can put a Spacer in an HStack to force the other views to move to the left side, or to the right side."
        case .picker:
            return "A Picker allows you to choose between a set of choices. Just like an HStack or a VStack, it can contain other views, like Text or Image. Or even an HStack with both Text *and* an Image!"
        case .list:
            return "A List allows you to show items one after the other, and helps you track which one is selected."
        }
    }
    
    var isContainer: Bool {
        self == .hStack || self == .vStack || self == .zStack || self == .picker || self == .list
    }
    
    static var draggableTypes: [Self] {
        Array(allCases.dropFirst(1))
    }
}
