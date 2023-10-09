import SwiftUI

struct ImageSizeModificationEditorView: View {

    @ObservedObject var imageSizeModification: ImageSizeModification
    let redrawEverything: () -> Void

    var body: some View {
        imageSizePicker
    }

    private var imageSizePicker: some View {
        Slider(value: $imageSizeModification.imageSize.animation(),
               in: 20...200,
               step: 2) {
            Text("Size")
        } minimumValueLabel: {
            Text("20")
        } maximumValueLabel: {
            Text("200")
        } onEditingChanged: { didChange in
            redrawEverything()
        }
    }
}

struct ImageSizeModificationEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSizeModificationEditorView(imageSizeModification: ImageSizeModification()) {
            
        }
    }
}
