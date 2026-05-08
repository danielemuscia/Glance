import SwiftUI
import Defaults

struct HeroBetweenView: View {
    let next: MBEvent
    var now: Date = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: Space.sm) {
            EyebrowView(text: "BETWEEN MEETINGS", style: .neutral)
            title
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Space.lg)
        .padding(.vertical, Space.xxl)
    }

    private var title: some View {
        HStack(spacing: 0) {
            Text("You're free until ")
                .font(Typography.display)
                .foregroundColor(.glanceInk1)
            Text(timeString)
                .font(Typography.display.monospacedDigit())
                .foregroundColor(.glanceAccent)
            Text(".")
                .font(Typography.display)
                .foregroundColor(.glanceInk1)
        }
        .lineLimit(1)
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.locale = I18N.instance.locale
        formatter.dateFormat = Defaults[.timeFormat] == .am_pm ? "h:mm a" : "HH:mm"
        return formatter.string(from: next.startDate)
    }
}
