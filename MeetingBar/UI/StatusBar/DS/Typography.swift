import SwiftUI

enum Typography {
    /// 22 bold — hero title
    static let display: Font = .system(size: 22, weight: .bold)

    /// 13 semibold — wordmark, strong row title
    static let subhead: Font = .system(size: 13, weight: .semibold)

    /// 13 medium — peek row title, footer button label, action label
    static let body: Font = .system(size: 13, weight: .medium)

    /// 12 regular — hero meta inline
    static let bodySm: Font = .system(size: 12)

    /// 12 medium — accordion label, peek row time
    static let bodySmMd: Font = .system(size: 12, weight: .medium)

    /// 12 mono digit — hero time range
    static let bodySmMono: Font = .system(size: 12).monospacedDigit()

    /// 11.5 regular — peek row subtitle
    static let caption: Font = .system(size: 11.5)

    /// 11.5 mono digit — header day-summary
    static let captionMono: Font = .system(size: 11.5).monospacedDigit()

    /// 11 semibold — eyebrow (use with `.tracking(0.5)` at the call site)
    static let eyebrow: Font = .system(size: 11, weight: .semibold)

    /// 10 semibold — inline label "NEXT" (use with `.tracking(0.5)`)
    static let microLabel: Font = .system(size: 10, weight: .semibold)
}
