import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            UIKitExampleView()
                .tabItem {
                    Label("UIKit", systemImage: "rectangle.grid.2x2")
                }

            SwiftUIExampleView()
                .tabItem {
                    Label("SwiftUI", systemImage: "square.grid.2x2")
                }
        }
    }
}
