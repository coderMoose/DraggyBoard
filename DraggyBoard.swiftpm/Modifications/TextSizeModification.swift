import Foundation

class TextSizeModification: Modification {
    @Published var selectedTextSize: TextSize = .body
    
    var isDefaultTextSize: Bool {
        selectedTextSize == .body
    }
}
