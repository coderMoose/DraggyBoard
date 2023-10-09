import SwiftUI

struct TextSizeModificationEditorView: View {

    @ObservedObject var textSizeModification: TextSizeModification
    let redrawEverything: () -> Void

    var body: some View {
        textSizePicker
    }
    
    private var textSizePicker: some View {
        Picker(selection: $textSizeModification.selectedTextSize.animation()) {
            ForEach(TextSize.allCases, id: \.name) { textSize in
                Text(textSize.name)
                    .font(textSize.font)
                    .tag(textSize)
            }
        } label: {
            Text("Text Size")
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: textSizeModification.selectedTextSize) { newValue in
            redrawEverything()
        }
    }
}

struct TextSizeModificationEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextSizeModificationEditorView(textSizeModification: TextSizeModification()) {
            
        }
    }
}
