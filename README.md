# ShinyUI

A simple declarative UI framework.
Currently, this project is in early development.

## Why "ShinyUI"?.

In the beginning, the swift programming language was called Shiny (as in “this new shiny thing”), that is the reason of the framework's name.

## What is not.

ShinyUI does not pretend imitate or copy SwiftU, It is just inspired in SwiftUI.

## Example

#### Simple counter

```swift
struct App: View {
    
    @State var count: Int = 0
    
    var body: View {
        VStack {
            Text("You have pushed the button this many times:")
                .font("", 15)
                .foregroundColor(Color(0x282828))
            Text("\(count)")
                .font("", 30)
                .foregroundColor(Color(0x282828))
                .margin(vertical(30))
            Text("🚀 Tap me")
                .font("", 20)
                .color(Color(0xFFFFFF, alpha: 0))
                .foregroundColor(Color(0xFFFFFF))
                .margin {
                    horizontal(15)
                    vertical(10)
                }
                .decorate {
                    color(Color(0xFF555B))
                    cornerRadius(25)
                }
                .onTap {
                    count += 1
                }
        }
        .center()
    }
}
```

Result:

macOS:

![alt demo](https://github.com/AngelLandoni/ShinyUI/blob/main/Assets/Readme/ExampleMacOS.png)

iOS:

![alt demo](https://github.com/AngelLandoni/ShinyUI/blob/main/Assets/Readme/ExampleiOS.png)
