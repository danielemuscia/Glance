import SwiftUI

struct HeroEmptyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Circle()
                    .stroke(Color.glanceInk2.opacity(0.45), lineWidth: 1)
                    .frame(width: 8, height: 8)
                Text("TODAY")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(.glanceInk2)
            }
            Text("Nothing scheduled.")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.glanceInk1)
            Text("Your day is yours. We'll surface the next thing whenever something lands on your calendar.")
                .font(.system(size: 13))
                .foregroundColor(.glanceInk2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.vertical, 24)
    }
}
