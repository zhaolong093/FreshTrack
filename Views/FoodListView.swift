//
//  FoodList.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//


import SwiftUI

struct FoodListView: View{
    @StateObject private var viewModel: FoodListViewModel
    
    init(viewModel: FoodListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View{
        Group {
            if viewModel.isLoading{
                ProgressView("Loading your food...")
            }
            
            else if viewModel.foodItems.isEmpty{
                emptyState
            }
            else {
                foodList
            }
        }
        .navigationTitle("My Food")
        .onAppear{
            viewModel.loadFoodItems()
        }
        .alert("Unable to Load Food", isPresented: $viewModel.showingError){
            Button("OK", role: .cancel){}
        } message:{
            Text(viewModel.errorMessage ?? "Something went wrong")
        }
    }
    
    //MARK: Food List
    
    private var foodList: some View{
        List{
            ForEach(viewModel.foodItems){
                foodItem in
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        Text(foodItem.name)
                            .font(.headline)
                        Spacer()
                        Text(foodItem.storageLocation.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack{
                        Text("Quantity : \(foodItem.quantity)")
                        
                        Spacer()
                        
                        Text(foodItem.expiryDate, format: .dateTime.day().month(.abbreviated).year())
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        
        .refreshable{
            viewModel.loadFoodItems()
        }
    }
    
    //MARK: Empty State
    
    private var emptyState: some View{
        ContentUnavailableView("No Food Added", systemImage: "refrigerator",  description: Text("Add your first food item to start tracking expiry dates."))
    }
}
