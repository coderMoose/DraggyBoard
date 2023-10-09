import Foundation

class TextNode: Node {

    @Published var displayText: String

    let textSizeModification = TextSizeModification()
    let textBoldModification = TextBoldModification()
    let textColorModification = TextColorModification()
    
    init(displayText: String, isBold: Bool = false, textSize: TextSize = .body, textColor: TextColor = .primary) {
        self.displayText = displayText
        textBoldModification.isBold = isBold
        textSizeModification.selectedTextSize = textSize
        textColorModification.textColor = textColor
        super.init(nodeType: .text, subNodes: nil)
    }
    
    override func asCode(indentLevel: Int = 0) -> String {
        let firstLine = "\(indentation(indentLevel))Text(\"\(displayText)\")"
        var allCode = firstLine

        if !textSizeModification.isDefaultTextSize {
            let textSizeModificationLine = "\(indentation(indentLevel + 1)).font(.\(textSizeModification.selectedTextSize.name))"
            allCode += "\n" + textSizeModificationLine
        }
        if textBoldModification.isBold {
            let textBoldModificationLine = "\(indentation(indentLevel + 1)).bold()"
            allCode += "\n" + textBoldModificationLine
        }
        if textColorModification.textColor != .primary {
            let textColorModificationLine = "\(indentation(indentLevel + 1)).foregroundColor(.\(textColorModification.textColor.rawValue)"
            allCode += "\n" + textColorModificationLine
        }
        return allCode
    }
}
