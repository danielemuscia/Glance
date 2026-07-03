// MenuPanelView.swift
// Width fixed 380. Height tracks the actual content (capped at 640 with scroll).
// Sticky bottom bar lives outside the ScrollView so it never scrolls away.
import SwiftUI

private struct ContentHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct MenuPanelView: View {
    @ObservedObject var viewModel: MenuViewModel

    @State private var contentHeight: CGFloat = 0

    private static let maxScrollHeight: CGFloat = 640

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            Color.clear.frame(height: 0).id("top")
                            MenuDropdownView(
                                events: viewModel.events,
                                selectedEventId: $viewModel.selectedEventId,
                                onCreateMeeting: { viewModel.createMeeting() },
                                onPreferences: { viewModel.openPreferences() }
                            )
                        }
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: ContentHeightKey.self,
                                    value: geo.size.height
                                )
                            }
                        )
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: min(contentHeight, Self.maxScrollHeight))
                    .onAppear { proxy.scrollTo("top", anchor: .top) }
                }

                BottomBarView(
                    onNewEvent: { viewModel.createMeeting() },
                    onPreferences: { viewModel.openPreferences() }
                )
            }
            .onPreferenceChange(ContentHeightKey.self) { newValue in
                Task { @MainActor in contentHeight = newValue }
            }

            if let event = viewModel.selectedEvent {
                DetailPanelView(
                    event: event,
                    onClose: { viewModel.selectedEventId = nil }
                )
                .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .frame(width: 380)
        .animation(.easeOut(duration: 0.22), value: viewModel.selectedEventId != nil)
        .animation(.easeOut(duration: 0.18), value: contentHeight)
        .onDisappear { viewModel.selectedEventId = nil }
    }
}
