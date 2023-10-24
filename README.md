## DraggyBoard

This is an app I built to help people learn SwiftUI, as part of the Apple 2023 Swift Student Challenge. Enjoy!

## SHOWCASE
The app has two modes: a mode where you follow tutorials made to introduce various SwiftUI views, and a mode where you get to build whatever you like.

Here's a demo of the tutorials mode:

<div align="center">
<video src="https://github.com/coderMoose/DraggyBoard/assets/130883757/00135d99-bb58-4e71-a683-1c5df614e453">
</div>


And here's a demo of the playground mode:
<div align="center">
<video src="https://github.com/coderMoose/DraggyBoard/main/assets/130883757/be83ddca-e426-45f5-bef1-4d34c3956b8f">
</div>



----

## BACKGROUND
I learned how to code using Swift Playgrounds about 7 years ago. I wanted to build an app that makes it just as easy to learn SwiftUI.


## RUNNING THE APP
- Please note, sometimes when you tap the Play button, Swift Playgrounds just displays a blank screen. If you see a blank screen, please tap the restart button, it always seems to work after that.

- This app is designed for iPad and looks best on iPad screen sizes. It requires iOS 16+ to work properly.


## FEATURES
- Tutorials that teach a user the basics of SwiftUI. Each tutorial comes with a list of tasks for the user to accomplish.
![tutorial_example](https://github.com/coderMoose/DraggyBoard/assets/130883757/1b12ebc1-dc62-49b0-9bcd-7731d771ebb4)



- A "Build your own app" mode where the user can drag views on to a board, and see a preview of what it'll look like, and the actual SwiftUI code that would draw it.

- This code can be copied to the clipboard. (Eventually I want to turn this into an App Store app, and would love to be able to generate a .swiftpm file that Playgrounds can open directly).

- Once you add views to the main VStack, you can click the blue arrow to expand it and see the views. If you tap on any of these views, you get an editor where you can do things like change colors, font sizes, etc...
![adding_views_example](https://github.com/coderMoose/DraggyBoard/assets/130883757/e869c36c-624e-4c00-9286-a50c7c7b7bc3)



- The grey bar on the right side is draggable - this allows the user to make the preview bigger or smaller.
![grey_bar_demo](https://github.com/coderMoose/DraggyBoard/assets/130883757/19d2df59-c905-4305-b531-cf9643f1b556)



- The user can switch between light and dark mode by clicking on the “…” button in the top right.
![dark_mode_demo](https://github.com/coderMoose/DraggyBoard/assets/130883757/d7a7a932-2791-4d87-a389-af711a1e83ae)




- The app supports both portrait and landscape. However, landscape will generally be more convenient.
 

## HOW IT WORKS
- I use a tree data structure to store a set of nodes, each one representing a view that goes on the screen.

- Each node is an ObservableObject - so when new subnodes are added, it's easy to animate the preview and the generated code.

- When drawing a preview, I walk along the tree recursively. Same for generating code. So for example, when drawing a VStack that contains an HStack that contains a ZStack, drawContainer will actually get called recursively 3 times. Long live recursion! recursion! recursio... 0x^#^@ error: stack overflow

- When I first started building this, I just used a simple SwiftUI TextEditor to show the code. It was a nice start, but I wanted to be able to add colors, and have new lines animate in. I didn't know how to do that with a TextEditor, so instead I decided to just stack a bunch of Text views together and show the code that way. Since each view is separate, I can use different colors and animate in different pieces at different times.

- For the tutorials, I can check if a user has completed a task by taking a look at the tree. ContainerNode has a lot of helper methods to make this easier.

- I used SwiftUI's OutlineGroup to show the tree in a way that the user could see the different levels. Unfortunately, I was not able to figure out how to make the nodes automatically expand when a new one is inserted (so the user has to tap the blue arrow themselves).


## NOTES
- The images used are provided by Apple, from the SF Symbols app. (The project itself doesn't contain any images, but rather the list of symbol/image names that SwiftUI allows you to load.)


## NEXT STEPS
In the future I would love to:
- Add some new lessons.
- Support way more modifiers, like padding, background color, opacity, etc...
- Get it working on macOS too.
- Send it to the App Store!

