import SwiftUI

@available(iOS 16, *)
struct ExplanationView: View {
    
    let explanation: String

    @EnvironmentObject private var nodeTracker: NodeSelectionTracker

    var body: some View {
        VStack {
            Text(explanation)
                .lineLimit(nil)
                .bold()
        }
        .padding()
        .background(Color.secondary.opacity(0.3))
        .cornerRadius(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(y: -10)
        .transition(.slide.combined(with: .opacity).animation(.easeInOut))
        .onTapGesture {
            nodeTracker.deselectAnthingThatIsSelected()
        }
    }
}

@available(iOS 16, *)
struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView(explanation: "Test")
    }
}
