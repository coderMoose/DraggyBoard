import SwiftUI

struct TextBoldModificationEditorView: View {

    @ObservedObject var textBoldModification: TextBoldModification
    let redrawEverything: () -> Void

    var body: some View {
        Toggle("Bold", isOn: $textBoldModification.isBold.animation())
            .onChange(of: textBoldModification.isBold) { newValue in
                redrawEverything()
            }
    }
}

struct TextBoldModificationEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextBoldModificationEditorView(textBoldModification: TextBoldModification()) {
            
        }
    }
}
