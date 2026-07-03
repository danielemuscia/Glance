import SwiftUI

struct EarlierTodayList: View {
    let events: [MBEvent]
    @Binding var expanded: Bool
    var onSelect: (String) -> Void

    var body: some View {
        if !events.isEmpty {
            VStack(spacing: 0) {
                AccordionDisclosure(
                    count: events.count,
                    label: events.count == 1 ? "earlier today" : "earlier today",
                    expanded: $expanded
                )
                if expanded {
                    VStack(spacing: 0) {
                        ForEach(events) { event in
                            PeekRowView(event: event, variant: .past) {
                                onSelect(event.id)
                            }
                        }
                    }
                    .padding(.bottom, 4)
                }
            }
        }
    }
}
