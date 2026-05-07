// GlanceStatusIcon.swift — Menu bar icon: G letterform + indicator dot.
// The dot pulses and turns glanceAccent when a meeting is in progress.
import SwiftUI

struct GlanceStatusIcon: View {
    let isMeetingActive: Bool
    @State private var pulseOpacity: Double = 1.0

    private let side: CGFloat = 22

    var body: some View {
        let s = side / 1024
        ZStack(alignment: .topLeading) {
            GLetterShape()
                .fill(Color.primary)

            Circle()
                .fill(isMeetingActive ? Color.glanceAccent : Color.primary)
                .frame(width: 112 * s, height: 112 * s)
                .offset(x: (850 - 56) * s, y: (466 - 56) * s)
                .opacity(isMeetingActive ? pulseOpacity : 1)
        }
        .frame(width: side, height: side)
        .onAppear { if isMeetingActive { startPulse() } }
        .onChange(of: isMeetingActive) { active in
            if active { startPulse() } else { stopPulse() }
        }
    }

    private func startPulse() {
        pulseOpacity = 1.0
        withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
            pulseOpacity = 0.3
        }
    }

    private func stopPulse() {
        withAnimation(.default) { pulseOpacity = 1.0 }
    }
}

// MARK: - G letterform shape (SVG viewBox 0 0 1024 1024)

private struct GLetterShape: Shape {
    func path(in rect: CGRect) -> Path {
        let sx = rect.width  / 1024
        let sy = rect.height / 1024
        func p(_ x: Double, _ y: Double) -> CGPoint { .init(x: x * sx, y: y * sy) }

        var path = Path()
        path.move(to: p(617.653, 384))
        path.addCurve(to: p(604.244, 354.682), control1: p(614.472, 372.939), control2: p(610.002, 363.167))
        path.addCurve(to: p(583.108, 332.864), control1: p(598.487, 346.045), control2: p(591.441, 338.773))
        path.addCurve(to: p(554.926, 319),     control1: p(574.926, 326.803), control2: p(565.532, 322.182))
        path.addCurve(to: p(520.153, 314.227), control1: p(544.472, 315.818), control2: p(532.881, 314.227))
        path.addCurve(to: p(457.426, 331.955), control1: p(496.366, 314.227), control2: p(475.456, 320.136))
        path.addCurve(to: p(415.608, 383.545), control1: p(439.547, 343.773), control2: p(425.608, 360.97))
        path.addCurve(to: p(400.608, 465.818), control1: p(405.608, 405.97),  control2: p(400.608, 433.394))
        path.addCurve(to: p(415.381, 548.545), control1: p(400.608, 498.242), control2: p(405.532, 525.818))
        path.addCurve(to: p(457.199, 600.591), control1: p(425.229, 571.273), control2: p(439.169, 588.621))
        path.addCurve(to: p(521.062, 618.318), control1: p(475.229, 612.409), control2: p(496.517, 618.318))
        path.addCurve(to: p(578.108, 606.5),   control1: p(543.335, 618.318), control2: p(562.35,  614.379))
        path.addCurve(to: p(614.472, 572.636), control1: p(594.017, 598.47),  control2: p(606.138, 587.182))
        path.addCurve(to: p(627.199, 521.045), control1: p(622.956, 558.091), control2: p(627.199, 540.894))
        // Horizontal bar — opening of the G
        path.addLine(to: p(647.199, 524))
        path.addLine(to: p(527.199, 524))
        path.addLine(to: p(527.199, 449.909))
        path.addLine(to: p(721.972, 449.909))
        path.addLine(to: p(721.972, 508.545))
        // Outer arc
        path.addCurve(to: p(696.062, 614),     control1: p(721.972, 549.455), control2: p(713.335, 584.606))
        path.addCurve(to: p(624.699, 681.727), control1: p(678.79,  643.242), control2: p(655.002, 665.818))
        path.addCurve(to: p(520.608, 705.364), control1: p(594.396, 697.485), control2: p(559.699, 705.364))
        path.addCurve(to: p(405.608, 676.5),   control1: p(476.972, 705.364), control2: p(438.638, 695.742))
        path.addCurve(to: p(328.335, 594),     control1: p(372.578, 657.106), control2: p(346.82,  629.606))
        path.addCurve(to: p(300.835, 466.727), control1: p(310.002, 558.242), control2: p(300.835, 515.818))
        path.addCurve(to: p(317.199, 365.818), control1: p(300.835, 429),     control2: p(306.29,  395.364))
        path.addCurve(to: p(363.562, 290.364), control1: p(328.259, 336.121), control2: p(343.714, 310.97))
        path.addCurve(to: p(432.881, 243.318), control1: p(383.411, 269.758), control2: p(406.517, 254.076))
        path.addCurve(to: p(518.562, 227.182), control1: p(459.244, 232.561), control2: p(487.805, 227.182))
        path.addCurve(to: p(592.199, 238.773), control1: p(544.926, 227.182), control2: p(569.472, 231.045))
        path.addCurve(to: p(652.653, 271.045), control1: p(614.926, 246.348), control2: p(635.078, 257.106))
        path.addCurve(to: p(696.062, 320.818), control1: p(670.381, 284.985), control2: p(684.85,  301.576))
        path.addCurve(to: p(717.653, 384),     control1: p(707.275, 339.909), control2: p(714.472, 360.97))
        path.addLine(to: p(617.653, 384))
        path.closeSubpath()
        return path
    }
}
