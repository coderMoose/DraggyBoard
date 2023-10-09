import SwiftUI

enum TextSize: CaseIterable {
    case body
    case callout
    case caption
    case caption2
    case footnote
    case headline
    case largeTitle
    case title
    case title2
    case title3
    
    var name: String {
        switch self {
        case .body:
            return "body"
        case .callout:
            return "callout"
        case .caption:
            return "caption"
        case .caption2:
            return "caption2"
        case .footnote:
            return "footnote"
        case .headline:
            return "headline"
        case .largeTitle:
            return "largeTitle"
        case .title:
            return "title"
        case .title2:
            return "title2"
        case .title3:
            return "title3"
        }
    }
    
    var font: Font {
        switch self {
        case .body:
            return .body
        case .callout:
            return .callout
        case .caption:
            return .caption
        case .caption2:
            return .caption2
        case .footnote:
            return .footnote
        case .headline:
            return .headline
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        }
    }
}
