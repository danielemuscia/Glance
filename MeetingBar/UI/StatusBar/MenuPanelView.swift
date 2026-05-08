// MenuPanelView.swift
// Width fixed 380. Height dynamic (min 280, max 640 with scroll above).
// Sticky bottom bar lives outside the ScrollView so it never scrolls away.
import SwiftUI

struct MenuPanelView: View {
    @ObservedObject var viewModel: MenuViewModel

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
                    }
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: 640)
                    .onAppear { proxy.scrollTo("top", anchor: .top) }
                }

                BottomBarView(
                    onNewEvent: { viewModel.createMeeting() },
                    onPreferences: { viewModel.openPreferences() }
                )
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
        .frame(minHeight: 280)
        .animation(.easeOut(duration: 0.22), value: viewModel.selectedEventId != nil)
        .onDisappear { viewModel.selectedEventId = nil }
    }
}
