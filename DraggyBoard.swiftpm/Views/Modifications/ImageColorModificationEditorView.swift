import SwiftUI

struct ImageColorModificationEditorView: View {
    
    @ObservedObject var imageColorModification: ImageColorModification
    let redrawEverything: () -> Void

    var body: some View {
        imageColorPicker
    }

    private var imageColorPicker: some View {
        Picker(selection: $imageColorModification.imageColor.animation()) {
            ForEach(TextColor.allCases, id: \.rawValue) { textColor in
                Text(textColor.rawValue)
                    .tag(textColor)
            }
        } label: {
            Text("Image Color")
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: imageColorModification.imageColor) { newValue in
            redrawEverything()
        }
    }
}


struct ImageColorModificationEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageColorModificationEditorView(imageColorModification: ImageColorModification()) {
            
        }
    }
}
