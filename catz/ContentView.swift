import SwiftUI

struct ContentView: View {
    @State private var selectedCreature = "black_mouse"
    @State private var numberOfCreatures = 1
    @State private var speed: Double = 1.0
    @State private var showGame = false

    let creatures = ["black_mouse", "gray_mouse"]

    var body: some View {
        VStack {
            Text("Cat Game")
                .font(.largeTitle)
                .padding()

            Picker("Select a Creature", selection: $selectedCreature) {
                ForEach(creatures, id: \.self) { creature in
                    Text(creature.replacingOccurrences(of: "_", with: " ").capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Stepper("Number of Creatures: \(numberOfCreatures)", value: $numberOfCreatures, in: 1...10)
                .padding()

            Slider(value: $speed, in: 0.5...3.0, step: 0.1) {
                Text("Speed")
            } minimumValueLabel: {
                Text("Slow")
            } maximumValueLabel: {
                Text("Fast")
            }
            .padding()

            Button("Start Game") {
                showGame = true
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showGame) {
                GameView(creature: selectedCreature, count: numberOfCreatures, speed: speed)
            }
        }
        .padding()
    }
}

struct GameView: View {
    let creature: String
    let count: Int
    let speed: Double

    @State private var positions: [CGPoint] = []

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { index in
                CreatureView(creature: creature, speed: speed, startPosition: randomPosition())
                    .position(positions.indices.contains(index) ? positions[index] : randomPosition())
                    .onAppear {
                        positions.append(randomPosition())
                    }
            }
        }
        .background(Color.blue)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
                positions = Array(repeating: CGPoint.zero, count: count).map { _ in randomPosition() }
            }
        }
    }

    private func randomPosition() -> CGPoint {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGPoint(x: CGFloat.random(in: 50...screenWidth - 50), y: CGFloat.random(in: 50...screenHeight - 50))
    }
}

struct CreatureView: View {
    let creature: String
    let speed: Double
    let startPosition: CGPoint

    @State private var currentPosition: CGPoint = .zero

    var body: some View {
        Image(creature)
            .resizable()
            .frame(width: 50, height: 50)
            .position(currentPosition) // Position the creature based on the currentPosition state.
            .onAppear {
                // Initialize currentPosition when the view appears.
                currentPosition = startPosition
                animateMovement()
            }
    }

    private func animateMovement() {
        withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
            currentPosition = CGPoint(x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
                                      y: CGFloat.random(in: 50...UIScreen.main.bounds.height - 50))
        }
    }
}


#Preview {
    ContentView()
}
