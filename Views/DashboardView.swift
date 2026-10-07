//
//  Dashboard.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject private var viewModel: DashboardViewModel
    
    let addFoodItemUseCase: AddFoodItemUseCase
    let viewFoodInventoryUseCase: ViewFoodInventoryUseCase
    let markFoodAsConsumedUseCase: MarkFoodAsConsumedUseCase
    let findExpiringFoodUseCase: FindExpiringFoodUseCase
    
    init(
        viewModel: DashboardViewModel,
        addFoodItemUseCase: AddFoodItemUseCase,
        viewFoodInventoryUseCase: ViewFoodInventoryUseCase,
        markFoodAsConsumedUseCase: MarkFoodAsConsumedUseCase,
        findExpiringFoodUseCase: FindExpiringFoodUseCase
    ) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
        self.addFoodItemUseCase = addFoodItemUseCase
        self.viewFoodInventoryUseCase = viewFoodInventoryUseCase
        self.markFoodAsConsumedUseCase = markFoodAsConsumedUseCase
        self.findExpiringFoodUseCase = findExpiringFoodUseCase
    }
    var body: some View{
        ScrollView{
            VStack(alignment: .leading, spacing: 24){
                Text("FreshTrack")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Track your food before it expires")
                    .foregroundStyle(.secondary)
                
                if viewModel.isLoading{
                    ProgressView()
                }
                else {
                    summarySection
                    
                    urgentFoodSection
                    
                    navigationSection
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .onAppear{viewModel.loadDashbaord()
        }
        
        .alert("Unable to Load Dashboard", isPresented: $viewModel.showingError){
            Button("OK", role: .cancel){}
            
        } message: {
            Text( viewModel.errorMessage ?? "Something went wrong.")
        }
    }
    
    //MARK: Summary
    private var summarySection: some View { 
        HStack(spacing: 16){
            VStack(spacing:8){
                Text("\(viewModel.totalFoodCount)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Food Items")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(spacing:8) {
                Text("\(viewModel.expiringFoodCount)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Expiring Soon")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    //MARK: Urgent Food
    
    private var urgentFoodSection : some View {
        VStack(alignment: .leading, spacing: 12){
            Text("Needs Attention")
                .font(.title2)
                .fontWeight(.semibold)
            
            if let food = viewModel.mostUrgentFood {
                VStack(alignment: .leading, spacing: 8){
                    Text(food.name)
                        .font(.headline)
                    
                    Text(viewModel.expiryMessage(for: food))
                        .font(.subheadline)
                    
                    Text("Stored in :\(food.storageLocation.name)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                ContentUnavailableView("Nothing Urgent",
                                       systemImage: "checkmark.circle", description: Text("No food is expiring within the next 3 days"))
            }
        }
    }
    
    //MARK: Navigation
    
    private var navigationSection: some View {
        VStack(spacing: 12){
            NavigationLink{
                FoodListView(viewModel: FoodListViewModel(viewFoodInventoryUseCase: viewFoodInventoryUseCase),
                             markFoodAsConsumedUseCase: markFoodAsConsumedUseCase
                )
            } label: {
                Label("My food", systemImage: "refrigerator")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink{
                AddFoodView(viewModel: AddFoodViewModel(addFoodItemUseCase: addFoodItemUseCase))
            } label: {
                Label("Add Food", systemImage: "plus.circle")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.bordered)
            
            NavigationLink{
                ExpiringSoonView(viewModel: ExpiringSoonViewModel(findExpiringFoodUseCase: findExpiringFoodUseCase))
            } label: {
                Label("Expiring Soon", systemImage: "clock.badge.exclamationmark")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.bordered)
        }
    }
}
