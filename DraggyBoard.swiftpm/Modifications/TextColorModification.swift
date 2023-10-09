import SwiftUI

// I tried to use SwiftUI's ColorPicker, but realized it'd be a bit hard to support *any* color.
// So instead, I used an enum to map to the common colors that SwiftUI provides.
enum TextColor: String, CaseIterable {
    case black
    case blue
    case brown
    case clear
    case cyan
    case gray
    case green
    case indigo
    case mint
    case orange
    case pink
    case purple
    case red
    case teal
    case white
    case yellow

    case accentColor
    case primary
    case secondary
    
    var color: Color {
        switch self {
        case .black:
            return .black
        case .blue:
            return .blue
        case .brown:
            return .brown
        case .clear:
            return .clear
        case .cyan:
            return .cyan
        case .gray:
            return .gray
        case .green:
            return .green
        case .indigo:
            return .indigo
        case .mint:
            return .mint
        case .orange:
            return .orange
        case .pink:
            return .pink
        case .purple:
            return .purple
        case .red:
            return .red
        case .teal:
            return .teal
        case .white:
            return .white
        case .yellow:
            return .yellow
        case .accentColor:
            return .accentColor
        case .primary:
            return .primary
        case .secondary:
            return .secondary
        }
    }
}

class TextColorModification: ObservableObject {
    @Published var textColor: TextColor = .primary
}
