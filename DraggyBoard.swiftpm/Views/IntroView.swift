import SwiftUI

@available(iOS 16, *)
struct IntroView: View {
    
    @State var colorScheme: ColorScheme
    
    @State private var pickLessonMode = false

    var body: some View {
        if isScreenSizeBigEnough {
            NavigationStack {
                mainContent
                    .preferredColorScheme(colorScheme)
            }
        } else {
            Text("DraggyBoard")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
            Text("This app is designed for larger screen sizes, please try this on a connected iPad or on an iPad simulator.")
                .font(.largeTitle)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
        }
    }
    
    private var isScreenSizeBigEnough: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var mainContent: some View {
        VStack {
            Spacer()
            Text("Welcome to DraggyBoard!")
                .font(.largeTitle)
                .bold()
            Text("The app that teaches you SwiftUI, through drag and drop.")
                .font(.title)
                .padding(.top)
            Spacer()
            if pickLessonMode {
                lessonButtons
                    .transition(.scale.combined(with: .opacity))
            } else {
                mainButtons
                    .transition(.scale.combined(with: .opacity))
            }
            Spacer()
            Spacer()
        }
    }
    
    @ViewBuilder
    private var lessonButtons: some View {
        Button {
            withAnimation {
                pickLessonMode = false
            }
        } label: {
            Label("Go Back", systemImage: "arrowshape.backward")
                .font(.largeTitle)
                .foregroundColor(.blue)
        }
        LazyVGrid(columns: [GridItem(.fixed(240)),
                            GridItem(.fixed(240)),
                            GridItem(.fixed(240))] ) {
            ForEach(LessonManager.allLessons) { lesson in
                NavigationLink {
                    ContentView(currentLesson: lesson, colorScheme: $colorScheme)
                } label: {
                    buttonLabel(named: lesson.name, width: 180)
                }
            }
        }
    }
    
    private func buttonLabel(named name: String, width: CGFloat) -> some View {
        Text(name)
            .frame(width: width)
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .padding(20)
            .background(Color.blue)
            .cornerRadius(20)
    }
    
    @ViewBuilder
    private var mainButtons: some View {
        Button {
            withAnimation {
                pickLessonMode = true
            }
        } label: {
            buttonLabel(named: "Tutorials", width: 250)
        }
        NavigationLink {
            ContentView(currentLesson: LessonManager.buildYourOwnChartLesson, colorScheme: $colorScheme)
        } label: {
            buttonLabel(named: "Create Charts", width: 250)
        }
        NavigationLink {
            ContentView(currentLesson: LessonManager.buildYourOwnAppLesson, colorScheme: $colorScheme)
        } label: {
            buttonLabel(named: "Build Any App", width: 250)
        }
    }
}

@available(iOS 16, *)
struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(colorScheme: .light)
    }
}
