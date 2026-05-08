import SwiftUI

struct HeroWrappedView: View {
    let doneCount: Int

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
            Text("All wrapped up.")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.glanceInk1)
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundColor(.glanceInk2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.vertical, 24)
    }

    private var subtitle: String {
        let noun = doneCount == 1 ? "meeting" : "meetings"
        return "\(doneCount) \(noun) done. Nice work."
    }
}
