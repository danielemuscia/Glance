// GlanceStatusIcon.swift — Menu bar icon: G letterform + indicator dot.
// The dot pulses and turns glanceAccent when a meeting is in progress.
import SwiftUI

struct GlanceStatusIcon: View {
    let isMeetingActive: Bool
    @State private var pulseOpacity: Double = 1.0

    // SVG viewBox is 1024×1024; we render at 22 pt (standard macOS menu bar height)
    private let side: CGFloat = 22

    var body: some View {
        let s = side / 1024

        ZStack(alignment: .topLeading) {
            Canvas { ctx, size in
                let cs = size.width / 1024
                ctx.fill(
                    glyphPath.applying(CGAffineTransform(scaleX: cs, y: cs)),
                    with: .foreground
                )
            }

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

    // MARK: - Pulse

    private func startPulse() {
        pulseOpacity = 1.0
        withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
            pulseOpacity = 0.3
        }
    }

    private func stopPulse() {
        withAnimation(.default) { pulseOpacity = 1.0 }
    }

    // MARK: - Glyph (SVG path, 1024×1024 coordinate space)

    private var glyphPath: Path {
        var p = Path()
        p.move(to: .init(x: 617.653, y: 384))
        p.addCurve(to: .init(x: 604.244, y: 354.682),
                   control1: .init(x: 614.472, y: 372.939),
                   control2: .init(x: 610.002, y: 363.167))
        p.addCurve(to: .init(x: 583.108, y: 332.864),
                   control1: .init(x: 598.487, y: 346.045),
                   control2: .init(x: 591.441, y: 338.773))
        p.addCurve(to: .init(x: 554.926, y: 319),
                   control1: .init(x: 574.926, y: 326.803),
                   control2: .init(x: 565.532, y: 322.182))
        p.addCurve(to: .init(x: 520.153, y: 314.227),
                   control1: .init(x: 544.472, y: 315.818),
                   control2: .init(x: 532.881, y: 314.227))
        p.addCurve(to: .init(x: 457.426, y: 331.955),
                   control1: .init(x: 496.366, y: 314.227),
                   control2: .init(x: 475.456, y: 320.136))
        p.addCurve(to: .init(x: 415.608, y: 383.545),
                   control1: .init(x: 439.547, y: 343.773),
                   control2: .init(x: 425.608, y: 360.97))
        p.addCurve(to: .init(x: 400.608, y: 465.818),
                   control1: .init(x: 405.608, y: 405.97),
                   control2: .init(x: 400.608, y: 433.394))
        p.addCurve(to: .init(x: 415.381, y: 548.545),
                   control1: .init(x: 400.608, y: 498.242),
                   control2: .init(x: 405.532, y: 525.818))
        p.addCurve(to: .init(x: 457.199, y: 600.591),
                   control1: .init(x: 425.229, y: 571.273),
                   control2: .init(x: 439.169, y: 588.621))
        p.addCurve(to: .init(x: 521.062, y: 618.318),
                   control1: .init(x: 475.229, y: 612.409),
                   control2: .init(x: 496.517, y: 618.318))
        p.addCurve(to: .init(x: 578.108, y: 606.5),
                   control1: .init(x: 543.335, y: 618.318),
                   control2: .init(x: 562.35, y: 614.379))
        p.addCurve(to: .init(x: 614.472, y: 572.636),
                   control1: .init(x: 594.017, y: 598.47),
                   control2: .init(x: 606.138, y: 587.182))
        p.addCurve(to: .init(x: 627.199, y: 521.045),
                   control1: .init(x: 622.956, y: 558.091),
                   control2: .init(x: 627.199, y: 540.894))
        // Horizontal bar (opening of the G)
        p.addLine(to: .init(x: 647.199, y: 524))
        p.addLine(to: .init(x: 527.199, y: 524))
        p.addLine(to: .init(x: 527.199, y: 449.909))
        p.addLine(to: .init(x: 721.972, y: 449.909))
        p.addLine(to: .init(x: 721.972, y: 508.545))
        // Outer curve — bottom-right arc
        p.addCurve(to: .init(x: 696.062, y: 614),
                   control1: .init(x: 721.972, y: 549.455),
                   control2: .init(x: 713.335, y: 584.606))
        p.addCurve(to: .init(x: 624.699, y: 681.727),
                   control1: .init(x: 678.79, y: 643.242),
                   control2: .init(x: 655.002, y: 665.818))
        p.addCurve(to: .init(x: 520.608, y: 705.364),
                   control1: .init(x: 594.396, y: 697.485),
                   control2: .init(x: 559.699, y: 705.364))
        p.addCurve(to: .init(x: 405.608, y: 676.5),
                   control1: .init(x: 476.972, y: 705.364),
                   control2: .init(x: 438.638, y: 695.742))
        p.addCurve(to: .init(x: 328.335, y: 594),
                   control1: .init(x: 372.578, y: 657.106),
                   control2: .init(x: 346.82, y: 629.606))
        p.addCurve(to: .init(x: 300.835, y: 466.727),
                   control1: .init(x: 310.002, y: 558.242),
                   control2: .init(x: 300.835, y: 515.818))
        p.addCurve(to: .init(x: 317.199, y: 365.818),
                   control1: .init(x: 300.835, y: 429),
                   control2: .init(x: 306.29, y: 395.364))
        p.addCurve(to: .init(x: 363.562, y: 290.364),
                   control1: .init(x: 328.259, y: 336.121),
                   control2: .init(x: 343.714, y: 310.97))
        p.addCurve(to: .init(x: 432.881, y: 243.318),
                   control1: .init(x: 383.411, y: 269.758),
                   control2: .init(x: 406.517, y: 254.076))
        p.addCurve(to: .init(x: 518.562, y: 227.182),
                   control1: .init(x: 459.244, y: 232.561),
                   control2: .init(x: 487.805, y: 227.182))
        p.addCurve(to: .init(x: 592.199, y: 238.773),
                   control1: .init(x: 544.926, y: 227.182),
                   control2: .init(x: 569.472, y: 231.045))
        p.addCurve(to: .init(x: 652.653, y: 271.045),
                   control1: .init(x: 614.926, y: 246.348),
                   control2: .init(x: 635.078, y: 257.106))
        p.addCurve(to: .init(x: 696.062, y: 320.818),
                   control1: .init(x: 670.381, y: 284.985),
                   control2: .init(x: 684.85, y: 301.576))
        p.addCurve(to: .init(x: 717.653, y: 384),
                   control1: .init(x: 707.275, y: 339.909),
                   control2: .init(x: 714.472, y: 360.97))
        p.addLine(to: .init(x: 617.653, y: 384))
        p.closeSubpath()
        return p
    }
}
