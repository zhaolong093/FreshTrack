//
//  FreshTrackWidget.swift
//  FreshTrackWidget
//
//  Created by 是她 on 7/10/2026.
//

import WidgetKit
import SwiftUI

// MARK: Timeline Entry
struct FreshTrackWidgetEntry: TimelineEntry {

    let date: Date
    let foodItems: [WidgetFoodItem]
}

//MARK: Timeline Provider
struct FreshTrackWidgetProvider: TimelineProvider {

    func placeholder(in context: Context) -> FreshTrackWidgetEntry {
        FreshTrackWidgetEntry(date: Date(),
            foodItems: [
                WidgetFoodItem(
                    id: UUID(),
                    name: "Milk",
                    expiryDate:
                        Calendar.current.date(byAdding: .day,value: 1,
                            to: Date()
                        ) ?? Date(),
                    storageLocation: "Fridge"
                )
            ]
        )
    }

    func getSnapshot(in context: Context,completion: @escaping (
            FreshTrackWidgetEntry) -> Void) {
        let entry = FreshTrackWidgetEntry(
            date: Date(),
            foodItems: WidgetDataStore.load())
        completion(entry)
    }

    func getTimeline(in context: Context,
        completion: @escaping (Timeline<FreshTrackWidgetEntry>) -> Void) {
        let foodItems = WidgetDataStore.load()

        let entry = FreshTrackWidgetEntry(
                date: Date(),
                foodItems: foodItems
            )

        let nextUpdate = Calendar.current.date(byAdding: .minute,value: 30,
                to: Date()
            ) ?? Date()

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

        completion(timeline)
    }
}

// MARK: Widget View
struct FreshTrackWidgetEntryView: View {

    var entry: FreshTrackWidgetEntry

    @Environment(\.widgetFamily)
    private var family
    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                smallWidget

            case .systemMedium:
                mediumWidget

            default:
                smallWidget
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var smallWidget: some View {

        VStack(alignment: .leading, spacing: 6) {

            HStack(spacing: 4) {

                Image(systemName: "leaf.fill")
                    .font(.caption)

                Text("FreshTrack")
                    .font(.caption)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }

            Spacer()

            if let food = entry.foodItems.first {

                Text(food.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)

                Text(
                    expiryMessage(
                        for: food
                    )
                )
                .font(.caption)
                .fontWeight(.semibold)

                Text(food.storageLocation)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

            } else {

                Text("Nothing expiring")
                    .font(.caption)
                    .fontWeight(.semibold)

                Text("Your food is looking good.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
    
    private var mediumWidget: some View {

        VStack(alignment: .leading, spacing: 8) {

            HStack(spacing: 5) {

                Image(systemName:"clock.badge.exclamationmark")

                Text("Expiring Soon")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            if entry.foodItems.isEmpty {

                Spacer()

                Text("Nothing is expiring within the next 3 days.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Spacer()

            } else {

                ForEach(
                    Array(entry.foodItems.prefix(3))
                ) { food in
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {

                            Text(food.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .lineLimit(1)

                            Text(food.storageLocation)
                                .font(.caption2)
                                .foregroundStyle(
                                    .secondary
                                )
                                .lineLimit(1)
                        }

                        Spacer()

                        Text(
                            expiryMessage(
                                for: food
                            )
                        )
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    }
                }
            }

            Spacer(minLength: 0)
        }
    }

    // MARK: Expiry Message

    private func expiryMessage(for food: WidgetFoodItem) -> String {

        let calendar = Calendar.current

        let today = calendar.startOfDay(for: Date())

        let expiry = calendar.startOfDay( for: food.expiryDate)

        let days = calendar.dateComponents([.day],from: today, to: expiry).day ?? 0

        switch days {

        case ..<0:
            return "Expired"

        case 0:
            return "Today"

        case 1:
            return "Tomorrow"

        default:
            return "\(days) days"
        }
    }
}

// MARK: Widget

struct FreshTrackWidget: Widget {

    let kind = "FreshTrackWidget"
    var body: some WidgetConfiguration {

        StaticConfiguration( kind: kind, provider: FreshTrackWidgetProvider()) { entry in

            FreshTrackWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(
            "FreshTrack Expiry"
        )
        .description(
            "See which food items need your attention."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}
