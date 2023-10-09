import SwiftUI

struct TextColorModificationEditorView: View {

    @ObservedObject var textColorModification: TextColorModification
    let redrawEverything: () -> Void

    var body: some View {
        textColorPicker
    }

    private var textColorPicker: some View {
        Picker(selection: $textColorModification.textColor.animation()) {
            ForEach(TextColor.allCases, id: \.rawValue) { textColor in
                Text(textColor.rawValue)
                    .tag(textColor)
            }
        } label: {
            Text("Text Color")
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: textColorModification.textColor) { newValue in
            redrawEverything()
        }
    }
}

struct TextColorModificationEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextColorModificationEditorView(textColorModification: TextColorModification()) {
            
        }
    }
}
