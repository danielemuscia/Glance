import SwiftUI

struct HeroEmptyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Space.sm) {
            EyebrowView(text: "TODAY", style: .neutral)
            Text("Nothing scheduled.")
                .font(Typography.display)
                .foregroundColor(.glanceInk1)
            Text("Your day is yours. We'll surface the next thing whenever something lands on your calendar.")
                .font(Typography.body)
                .foregroundColor(.glanceInk2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Space.lg)
        .padding(.vertical, Space.xxl)
    }
}
