import SwiftUI

struct CardFanView: View {
    let cards: [TarotCard]
    let selectedIndices: Set<Int>
    let onTap: (Int) -> Void

    private let gold = Color(hex: "b58a33")
    private let frontBlue = Color(hex: "0f1e73")
    private let backBlue = Color(hex: "23235f")

    var body: some View {
        GeometryReader { geo in
            let count = min(cards.count, 15)
            let centerX = geo.size.width / 2
            let baseY = geo.size.height * 0.84
            let radius = min(geo.size.width * 0.60, 245.0)
            let totalArc: Double = 118

            ZStack {
                ForEach(0..<count, id: \.self) { index in
                    let angle = angleForCard(index: index, total: count, totalArc: totalArc)
                    let radians = angle * .pi / 180
                    let x = centerX + CGFloat(sin(radians)) * radius
                    let y = baseY - CGFloat(cos(radians)) * radius
                    let isSelected = selectedIndices.contains(index)

                    TarotBackCard(isSelected: isSelected)
                        .frame(width: 100, height: 158)
                        .rotationEffect(.degrees(angle))
                        .position(x: x, y: y)
                        .offset(y: isSelected ? -18 : 0)
                        .shadow(
                            color: Color.black.opacity(isSelected ? 0.35 : 0.18),
                            radius: isSelected ? 12 : 6,
                            y: isSelected ? 8 : 4
                        )
                        .zIndex(isSelected ? 200 + Double(index) : Double(index))
                        .onTapGesture {
                            onTap(index)
                        }
                        .animation(.spring(response: 0.34, dampingFraction: 0.82), value: selectedIndices)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func angleForCard(index: Int, total: Int, totalArc: Double) -> Double {
        guard total > 1 else { return 0 }
        let progress = Double(index) / Double(total - 1)
        return -totalArc / 2 + progress * totalArc
    }
}

private struct TarotBackCard: View {
    let isSelected: Bool

    private let gold = Color(hex: "b58a33")
    private let outerBlue = Color(hex: "23235f")
    private let innerBlue = Color(hex: "1f2d82")

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .fill(
                    LinearGradient(
                        colors: [
                            outerBlue,
                            innerBlue
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .stroke(gold.opacity(isSelected ? 0.95 : 0.55), lineWidth: isSelected ? 2.2 : 1.5)
                )

            RoundedRectangle(cornerRadius: 9)
                .stroke(gold.opacity(isSelected ? 0.42 : 0.18), lineWidth: 1)
                .padding(9)

            Image(systemName: "sparkle")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color(hex: "eadfb1").opacity(isSelected ? 0.95 : 0.85))
        }
        .scaleEffect(isSelected ? 1.03 : 1.0)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color.black,
                Color(hex: "020814"),
                Color(hex: "07163c")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        CardFanView(
            cards: TarotDeck.shuffled(),
            selectedIndices: [2, 7, 11],
            onTap: { _ in }
        )
        .frame(height: 380)
        .padding()
    }
}
