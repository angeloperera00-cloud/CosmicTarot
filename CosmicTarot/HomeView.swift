import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: TarotViewModel

    private let gold = Color(hex: "d8a83c")
    private let textGold = Color(hex: "e8c77a")
    private let cardBlue = Color(hex: "0c1550")

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let safeTop = geo.safeAreaInsets.top

            ZStack {
                // Home background
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

                StarfieldView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: max(8, safeTop - 4))

                    topMessageBox
                        .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 16)

                    CosmicButton(
                        title: "CLICK TO CHOOSE YOUR FATE",
                        style: .primary
                    ) {
                        vm.startReading()
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 16)

                    tarotImageCard(width: min(width - 48, 320))

                    Spacer()
                        .frame(height: 16)

                    CosmicButton(
                        title: "CLICK TO LET US CHOOSE FOR YOU",
                        style: .secondary
                    ) {
                        vm.autoChoose()
                    }
                    .padding(.horizontal, 24)

                    Spacer()

                    Color.clear
                        .frame(height: 92)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }

    private var topMessageBox: some View {
        Text("EMBRACE THE JOURNEY,\nTHE COSMOS ALIGNS FOR YOU")
            .font(.custom("Cinzel-Regular", size: 17))
            .kerning(1.2)
            .multilineTextAlignment(.center)
            .foregroundColor(textGold)
            .lineSpacing(7)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(cardBlue.opacity(0.94))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(gold, lineWidth: 2.5)
                    )
            )
            .shadow(color: gold.opacity(0.16), radius: 10)
    }

    private func tarotImageCard(width: CGFloat) -> some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 24)
                .fill(cardBlue.opacity(0.94))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(gold, lineWidth: 2.5)
                )
                .shadow(color: gold.opacity(0.18), radius: 14)

            Image("fortuneTeller")
                .resizable()
                .scaledToFit()
                .frame(width: width - 22)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(11)

            Text("")
                .font(.custom("Cinzel-Regular", size: 11))
                .kerning(1.2)
                .foregroundColor(textGold.opacity(0.9))
                .padding(.bottom, 18)
        }
        .frame(width: width, height: width * 1.15)
    }
}

#Preview {
    HomeView(vm: TarotViewModel())
        .preferredColorScheme(.dark)
}
