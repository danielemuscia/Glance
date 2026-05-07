// GlanceStatusIcon.swift — Menu bar icon: G letterform + indicator dot.
// Both shapes are rendered inside the template NSImage so light/dark is handled by the system.
// When a meeting is active, a glanceAccent Circle overlays the dot position with a pulse animation.
import SwiftUI
import AppKit

struct GlanceStatusIcon: View {
    let isMeetingActive: Bool
    @State private var pulseOpacity: Double = 1.0

    private static let pt: CGFloat = 22
    // Dot center in pt, matching SVG cx=850 cy=466 r=56 in a 1024 viewBox
    private static let dotD: CGFloat = 112.0 / 1024 * pt  // ≈ 2.4 pt
    private static let dotX: CGFloat = 850.0 / 1024 * pt  // center ≈ 18.3 pt
    private static let dotY: CGFloat = 466.0 / 1024 * pt  // center ≈ 10.0 pt

    var body: some View {
        ZStack(alignment: .topLeading) {
            // G + dot rendered as template — adapts to light/dark automatically
            Image(nsImage: Self.gImage)
                .resizable()
                .frame(width: Self.pt, height: Self.pt)

            // Accent overlay shown only when a meeting is active
            if isMeetingActive {
                let d = Self.dotD
                Circle()
                    .fill(Color.glanceAccent)
                    .frame(width: d, height: d)
                    .offset(x: Self.dotX - d / 2, y: Self.dotY - d / 2)
                    .opacity(pulseOpacity)
            }
        }
        .frame(width: Self.pt, height: Self.pt)
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

    // MARK: - G letterform as template NSImage (rendered once at launch)
    //
    // NSImage coordinate system has y=0 at bottom; SVG has y=0 at top.
    // We apply a transform (scale + y-flip) so we can use the original
    // SVG coordinates directly without recalculating every point.

    static let gImage: NSImage = {
        let pt = GlanceStatusIcon.pt
        let image = NSImage(size: NSSize(width: pt, height: pt))
        image.lockFocus()

        let tf = NSAffineTransform()
        tf.translateX(by: 0, yBy: pt)
        tf.scaleX(by: pt / 1024, yBy: -(pt / 1024))
        tf.concat()

        let path = NSBezierPath()
        path.move(to: .init(x: 617.653, y: 384))
        path.curve(to: .init(x: 604.244, y: 354.682), controlPoint1: .init(x: 614.472, y: 372.939), controlPoint2: .init(x: 610.002, y: 363.167))
        path.curve(to: .init(x: 583.108, y: 332.864), controlPoint1: .init(x: 598.487, y: 346.045), controlPoint2: .init(x: 591.441, y: 338.773))
        path.curve(to: .init(x: 554.926, y: 319),     controlPoint1: .init(x: 574.926, y: 326.803), controlPoint2: .init(x: 565.532, y: 322.182))
        path.curve(to: .init(x: 520.153, y: 314.227), controlPoint1: .init(x: 544.472, y: 315.818), controlPoint2: .init(x: 532.881, y: 314.227))
        path.curve(to: .init(x: 457.426, y: 331.955), controlPoint1: .init(x: 496.366, y: 314.227), controlPoint2: .init(x: 475.456, y: 320.136))
        path.curve(to: .init(x: 415.608, y: 383.545), controlPoint1: .init(x: 439.547, y: 343.773), controlPoint2: .init(x: 425.608, y: 360.97))
        path.curve(to: .init(x: 400.608, y: 465.818), controlPoint1: .init(x: 405.608, y: 405.97),  controlPoint2: .init(x: 400.608, y: 433.394))
        path.curve(to: .init(x: 415.381, y: 548.545), controlPoint1: .init(x: 400.608, y: 498.242), controlPoint2: .init(x: 405.532, y: 525.818))
        path.curve(to: .init(x: 457.199, y: 600.591), controlPoint1: .init(x: 425.229, y: 571.273), controlPoint2: .init(x: 439.169, y: 588.621))
        path.curve(to: .init(x: 521.062, y: 618.318), controlPoint1: .init(x: 475.229, y: 612.409), controlPoint2: .init(x: 496.517, y: 618.318))
        path.curve(to: .init(x: 578.108, y: 606.5),   controlPoint1: .init(x: 543.335, y: 618.318), controlPoint2: .init(x: 562.35, y: 614.379))
        path.curve(to: .init(x: 614.472, y: 572.636), controlPoint1: .init(x: 594.017, y: 598.47),  controlPoint2: .init(x: 606.138, y: 587.182))
        path.curve(to: .init(x: 627.199, y: 521.045), controlPoint1: .init(x: 622.956, y: 558.091), controlPoint2: .init(x: 627.199, y: 540.894))
        // Horizontal bar — opening of the G
        path.line(to: .init(x: 647.199, y: 524))
        path.line(to: .init(x: 527.199, y: 524))
        path.line(to: .init(x: 527.199, y: 449.909))
        path.line(to: .init(x: 721.972, y: 449.909))
        path.line(to: .init(x: 721.972, y: 508.545))
        // Outer arc
        path.curve(to: .init(x: 696.062, y: 614),     controlPoint1: .init(x: 721.972, y: 549.455), controlPoint2: .init(x: 713.335, y: 584.606))
        path.curve(to: .init(x: 624.699, y: 681.727), controlPoint1: .init(x: 678.79,  y: 643.242), controlPoint2: .init(x: 655.002, y: 665.818))
        path.curve(to: .init(x: 520.608, y: 705.364), controlPoint1: .init(x: 594.396, y: 697.485), controlPoint2: .init(x: 559.699, y: 705.364))
        path.curve(to: .init(x: 405.608, y: 676.5),   controlPoint1: .init(x: 476.972, y: 705.364), controlPoint2: .init(x: 438.638, y: 695.742))
        path.curve(to: .init(x: 328.335, y: 594),     controlPoint1: .init(x: 372.578, y: 657.106), controlPoint2: .init(x: 346.82,  y: 629.606))
        path.curve(to: .init(x: 300.835, y: 466.727), controlPoint1: .init(x: 310.002, y: 558.242), controlPoint2: .init(x: 300.835, y: 515.818))
        path.curve(to: .init(x: 317.199, y: 365.818), controlPoint1: .init(x: 300.835, y: 429),     controlPoint2: .init(x: 306.29,  y: 395.364))
        path.curve(to: .init(x: 363.562, y: 290.364), controlPoint1: .init(x: 328.259, y: 336.121), controlPoint2: .init(x: 343.714, y: 310.97))
        path.curve(to: .init(x: 432.881, y: 243.318), controlPoint1: .init(x: 383.411, y: 269.758), controlPoint2: .init(x: 406.517, y: 254.076))
        path.curve(to: .init(x: 518.562, y: 227.182), controlPoint1: .init(x: 459.244, y: 232.561), controlPoint2: .init(x: 487.805, y: 227.182))
        path.curve(to: .init(x: 592.199, y: 238.773), controlPoint1: .init(x: 544.926, y: 227.182), controlPoint2: .init(x: 569.472, y: 231.045))
        path.curve(to: .init(x: 652.653, y: 271.045), controlPoint1: .init(x: 614.926, y: 246.348), controlPoint2: .init(x: 635.078, y: 257.106))
        path.curve(to: .init(x: 696.062, y: 320.818), controlPoint1: .init(x: 670.381, y: 284.985), controlPoint2: .init(x: 684.85,  y: 301.576))
        path.curve(to: .init(x: 717.653, y: 384),     controlPoint1: .init(x: 707.275, y: 339.909), controlPoint2: .init(x: 714.472, y: 360.97))
        path.line(to: .init(x: 617.653, y: 384))
        path.close()

        NSColor.black.setFill()
        path.fill()

        // Dot — SVG <circle cx="850" cy="466" r="56">
        let dotPath = NSBezierPath(ovalIn: CGRect(x: 794, y: 410, width: 112, height: 112))
        dotPath.fill()

        image.unlockFocus()
        image.isTemplate = true
        return image
    }()
}
