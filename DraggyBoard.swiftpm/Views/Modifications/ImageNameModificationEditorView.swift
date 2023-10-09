import SwiftUI

@available(iOS 16, *)
struct ImageNameModificationEditorView: View {

    @ObservedObject var imageNode: SystemImageNode
    let redrawEverything: () -> Void
    
    @State private var showImagePicker = false
    @State private var searchText = ""

    var body: some View {
        Label("Pick Image", systemImage: "photo")
            .font(.title2)
            .foregroundColor(.blue)
            .onTapGesture {
                withAnimation {
                    showImagePicker = true
                }
                
            }
            .padding(.top)
            .sheet(isPresented: $showImagePicker) {
                imageSheet
            }
    }
    
    private var imageSheet: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    ImageGridView(imageNode: imageNode, searchText: $searchText, showImagePicker: $showImagePicker)
                        .padding(.bottom, 400)
                }
            }
        }
    }
}

private struct ImageGridView: View {

    @ObservedObject var imageNode: SystemImageNode
    @Binding var searchText: String
    @Binding var showImagePicker: Bool
    
    var body: some View {
        VStack {
            Text("The SF Symbols app gives you tons of great images you can use in your app.")
                .multilineTextAlignment(.center)
                .padding(.top)
                .padding(.horizontal)
                .padding(.horizontal)
            imageGrid
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Text("Color")
                            ImageColorModificationEditorView(imageColorModification: imageNode.imageColorModification) {
                                // No need to do anything for the redrawEverything call here
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .searchable(text: $searchText.animation(), placement: .toolbar, prompt: "Search for an image")
        }
    }

    private var imageGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(minimum: 40, maximum: 80)),
                            GridItem(.flexible(minimum: 40, maximum: 80)),
                            GridItem(.flexible(minimum: 40, maximum: 80)),
                            GridItem(.flexible(minimum: 40, maximum: 80)),
                            GridItem(.flexible(minimum: 40, maximum: 80)),
                            GridItem(.flexible(minimum: 40, maximum: 80))]) {
            ForEach(searchResults, id: \.self) { imageName in
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(imageNode.imageColorModification.imageColor.color)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            showImagePicker = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation {
                                imageNode.systemImageName = imageName
                            }
                        }
                    }
            }
        }
    }
    
    private var searchResults: [String] {
        if searchText == "" {
            return imagesPastedFromSFSymbols
        }
        let results = imagesPastedFromSFSymbols.filter {
            $0.contains(searchText.lowercased())
        }
        return results
    }
}

@available(iOS 16, *)
struct ImageNameModificationEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageNameModificationEditorView(imageNode: SystemImageNode(systemImageName: "photo")) {
            
        }
    }
}
