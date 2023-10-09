import SwiftUI

@main
@available(iOS 16, *)
struct DraggyBoardApp: App {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some Scene {
        WindowGroup {
            IntroView(colorScheme: colorScheme)
        }
    }
}
