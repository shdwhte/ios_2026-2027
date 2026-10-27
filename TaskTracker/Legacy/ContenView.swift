import SwiftUI

struct ContentView: View {
    @State private var output: [String] = []

    var body: some View {
        List(Array(output.enumerated()), id: \.offset) { item in
            Text(item.element)
        }
        .onAppear {
            output = runScenario()
            output.forEach { print($0) }
        }
    }
}

#Preview {
    ContentView()
}