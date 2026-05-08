import SwiftUI
import Defaults

struct HeroBetweenView: View {
    let next: MBEvent
    var now: Date = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            eyebrow
            title
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
    }

    private var eyebrow: some View {
        HStack(spacing: 6) {
            Circle()
                .stroke(Color.glanceInk2.opacity(0.45), lineWidth: 1)
                .frame(width: 8, height: 8)
            Text("BETWEEN MEETINGS")
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.5)
                .foregroundColor(.glanceInk2)
        }
    }

    private var title: some View {
        HStack(spacing: 0) {
            Text("You're free until ")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.glanceInk1)
            Text(timeString)
                .font(.system(size: 22, weight: .bold).monospacedDigit())
                .foregroundColor(.glanceAccent)
            Text(".")
                .font(.system(size: 22, weight: .bold))
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
