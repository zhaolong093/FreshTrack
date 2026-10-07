//
//  FoodDetails.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import SwiftUI

struct FoodDetailsView: View {
    
    @StateObject private var viewModel: FoodDetailsViewModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    let onConsumed: () -> Void
    
    init(viewModel: FoodDetailsViewModel, onConsumed: @escaping () -> Void = {}) {
        
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onConsumed = onConsumed
    }
    var body: some View {
        Form{
            Section("Food Details"){
                LabeledContent("Name", value: viewModel.foodItem.name)
                
                LabeledContent("Quantity", value: "\(viewModel.foodItem.quantity)")
                
                LabeledContent("Stored In", value: viewModel.foodItem.storageLocation.name)
            }
            
            Section("Dates"){
                LabeledContent("Purchase Date"){
                    Text(viewModel.foodItem.purchaseDate, format: .dateTime.day().month(.abbreviated).year())
                }
                
                LabeledContent("Expiry Date"){
                    Text(viewModel.foodItem.expiryDate, format: .dateTime.day().month(.abbreviated).year())
                }
            }
            
            Section{
                if viewModel.foodItem.isConsumed{
                    Label("Consumed", systemImage: "checkmark.circle.fill")
                }
                else {
                    Button {
                        viewModel.markAsConsumed()
                    }
                    label: {
                        Label("Mark as Consumed", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        
        .navigationTitle("Food Details")
        .alert("Unable to Update Food", isPresented: $viewModel.showingError){
            Button("OK", role: .cancel){}
        } message: {
            Text(viewModel.errorMessage ?? "Something went wrong")
        }
        .onChange(of: viewModel.didMarkAsConsumed){ _, newValue in
            if newValue{
                onConsumed()
                
                dismiss()
            }
        }
    }
}
