import SwiftUI

struct HeroWrappedView: View {
    let doneCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: Space.sm) {
            EyebrowView(text: "TODAY", style: .neutral)
            Text("All wrapped up.")
                .font(Typography.display)
                .foregroundColor(.glanceInk1)
            Text(subtitle)
                .font(Typography.body)
                .foregroundColor(.glanceInk2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Space.lg)
        .padding(.vertical, Space.xxl)
    }

    private var subtitle: String {
        let noun = doneCount == 1 ? "meeting" : "meetings"
        return "\(doneCount) \(noun) done. Nice work."
    }
}
