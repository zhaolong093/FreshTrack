//
//  FreshTrackWidgetLiveActivity.swift
//  FreshTrackWidget
//
//  Created by 是她 on 7/10/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FreshTrackWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FreshTrackWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FreshTrackWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FreshTrackWidgetAttributes {
    fileprivate static var preview: FreshTrackWidgetAttributes {
        FreshTrackWidgetAttributes(name: "World")
    }
}

extension FreshTrackWidgetAttributes.ContentState {
    fileprivate static var smiley: FreshTrackWidgetAttributes.ContentState {
        FreshTrackWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FreshTrackWidgetAttributes.ContentState {
         FreshTrackWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FreshTrackWidgetAttributes.preview) {
   FreshTrackWidgetLiveActivity()
} contentStates: {
    FreshTrackWidgetAttributes.ContentState.smiley
    FreshTrackWidgetAttributes.ContentState.starEyes
}
