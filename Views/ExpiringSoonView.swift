//
//  ExpiringSoon.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import SwiftUI
struct ExpiringSoonView: View {
    @StateObject private var viewModel: ExpiringSoonViewModel
    
    init(viewModel: ExpiringSoonViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Checking expiry dates...")
            }
            else if viewModel.foodItems.isEmpty {
                emptyState
            } else {
                expiringList
            }
        }
        .navigationTitle("Expiring Soon")
        .onAppear {
            viewModel.loadExpiringFood()
        }
        .alert("Unable to Load Food",isPresented:$viewModel.showingError)
        {
            Button("OK",role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "Something went wrong.")
        }
    }
    
    // MARK: - Expiring List
    private var expiringList: some View{
        List {
            Section("Next 3 Days")
            {
                ForEach(viewModel.foodItems)
                { foodItem in
                    VStack(alignment: .leading,spacing: 8)
                    {
                        HStack {
                            Text(foodItem.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(foodItem.storageLocation.name)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text(viewModel.expiryMessage(for: foodItem))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("Quantity: \(foodItem.quantity)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical,4)
                    }
                }
            }
            .refreshable {viewModel.loadExpiringFood()}
        }
    }
    // MARK: - Empty State
    private var emptyState: some View {
        ContentUnavailableView("Nothing Expiring Soon",
                               systemImage:"checkmark.circle",
                               description: Text("You have no active food expiring within the next 3 days."))
    }
}

