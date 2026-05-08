import SwiftUI

struct MoreTodayList: View {
    let events: [MBEvent]
    @Binding var expanded: Bool
    var onSelect: (String) -> Void

    var body: some View {
        if events.count == 1 {
            PeekRowView(
                event: events[0],
                variant: .upcoming,
                inlineLabel: "NEXT"
            ) {
                onSelect(events[0].id)
            }
        } else if events.count > 1 {
            VStack(spacing: 0) {
                AccordionDisclosure(
                    count: events.count,
                    label: "more today",
                    expanded: $expanded
                )
                if expanded {
                    VStack(spacing: 0) {
                        ForEach(Array(events.enumerated()), id: \.element.id) { idx, event in
                            PeekRowView(
                                event: event,
                                variant: .upcoming,
                                inlineLabel: idx == 0 ? "NEXT" : nil
                            ) {
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
