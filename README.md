# FreshTrack

## Domain Context
FreshTrack helps young adults living independently manage household
groceries and identify food approaching expiry.

## Stakeholder
Young adults under 35 who are responsible for managing their own
household groceries.

## Architecture
View → ViewModel → Use Case → FoodRepository →
CoreDataFoodRepository → Core Data

## Database Choice
FreshTrack uses Core Data because the information is private,
device-local, fast to access and needs to work offline.

Entities:
- FoodItemEntity
- StorageLocationEntity

Relationship:
StorageLocationEntity 1 → many FoodItemEntity

## System Extensions

### WidgetKit
Displays food approaching expiry without requiring the main app to
be opened. Supports small and medium widget families.

### Notification Content Extension
Displays domain-specific expiry information including food name,
storage location, quantity and expiry urgency.

## App Group
group.au.edu.uts.FreshTrack

## Unit Testing
Uses MockFoodRepository to test Use Cases without the real Core Data
stack.

## Setup
1. Open FreshTrack.xcodeproj.
2. Select an Apple Development Team for FreshTrack and extension targets.
3. Confirm App Group `group.au.edu.uts.FreshTrack` is enabled for
   FreshTrack and FreshTrackWidgetExtension.
4. Run FreshTrack on an iOS Simulator.
5. Allow notification permission when requested.
6. Run unit tests with Command-U.

Author: Thailong Chrin 
Student ID: 25150653
