import SwiftUI

struct PickCardsView: View {
    @ObservedObject var vm: TarotViewModel
    @Environment(\.dismiss) private var dismiss

    private let gold = Color(hex: "e0b24a")
    private let softGold = Color(hex: "b58d62")
    private let inputBlue = Color(hex: "1a2565")

    var body: some View {
        GeometryReader { _ in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: "020611"),
                        Color(hex: "04124a"),
                        Color(hex: "020919")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                StarfieldView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 6)

                    topBar
                        .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 10)

                    titleSection
                        .padding(.horizontal, 28)

                    Spacer()
                        .frame(height: 18)

                    questionInput
                        .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 18)

                    cardArea
                        .frame(height: 430)

                    Spacer()
                        .frame(height: 12)

                    Button {
                        vm.proceedToShake()
                    } label: {
                        Text("PROCEED TO REVEAL ✦")
                            .font(.custom("Cinzel-Regular", size: 12))
                            .kerning(2.4)
                            .foregroundColor(.white.opacity(vm.canProceed ? 0.95 : 0.4))
                            .frame(maxWidth: .infinity)
                            .frame(height: 66)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(hex: "9a66ff"),
                                                Color(hex: "7b42d9")
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                        .opacity(vm.canProceed ? 1.0 : 0.45)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!vm.canProceed)
                    .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 84)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }

    private var topBar: some View {
        HStack {
            Button {
                if !vm.navigationPath.isEmpty {
                    vm.navigationPath.removeLast()
                } else {
                    dismiss()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )

                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white.opacity(0.95))
                }
                .frame(width: 52, height: 52)
            }
            .buttonStyle(.plain)

            Spacer()
        }
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("PICK 3 CARDS")
                .font(.custom("Cinzel-Regular", size: 28))
                .kerning(3.6)
                .foregroundColor(gold)

            Text("Choose your card, feel the connection")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(softGold)
        }
    }

    private var questionInput: some View {
        HStack(spacing: 0) {
            TextField(
                "",
                text: Binding(
                    get: { vm.question },
                    set: { vm.question = $0 }
                ),
                prompt: Text("Ask your question...")
                    .foregroundColor(.white.opacity(0.34))
            )
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 18)
            .frame(height: 66)

            Button {
            } label: {
                ZStack {
                    Rectangle()
                        .fill(inputBlue.opacity(0.95))

                    Image(systemName: "mic")
                        .font(.system(size: 26, weight: .regular))
                        .foregroundColor(softGold)
                }
                .frame(width: 98, height: 66)
            }
            .buttonStyle(.plain)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(gold.opacity(0.35), lineWidth: 1)
                )
        )
    }

    private var cardArea: some View {
        ZStack(alignment: .bottom) {
            Ellipse()
                .fill(Color(hex: "2e3fa3").opacity(0.22))
                .frame(width: 290, height: 72)
                .blur(radius: 2)
                .offset(y: -6)

            Text(vm.selectedCardIndices.count == 3
                 ? "Your 3 cards are ready"
                 : "Select 3 cards from the deck")
                .font(.custom("Cinzel-Regular", size: 15))
                .italic()
                .foregroundColor(softGold)
                .offset(y: -32)
                .zIndex(1)

            CardFanView(
                cards: vm.deckCards,
                selectedIndices: vm.selectedCardIndices,
                onTap: { index in
                    vm.toggleCard(index: index)
                }
            )
        }
    }
}

#Preview {
    PickCardsView(vm: TarotViewModel())
        .preferredColorScheme(.dark)
}
