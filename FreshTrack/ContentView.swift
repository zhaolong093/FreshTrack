//
//  ContentView.swift
//  FreshTrack
//
//  Created by 是她 on 2/10/2026.
//

import SwiftUI

struct ContentView: View {
    
    let addFoodItemUseCase: AddFoodItemUseCase
    let viewFoodInventoryUseCase: ViewFoodInventoryUseCase
    let markFoodAsConsumedUseCase: MarkFoodAsConsumedUseCase
    let findExpiringFoodUseCase: FindExpiringFoodUseCase
    
    var body: some View {
        NavigationStack {
            
            DashboardView(
                viewModel: DashboardViewModel(
                    findExpiringFoodUseCase: findExpiringFoodUseCase,
                    viewFoodInventoryUseCase: viewFoodInventoryUseCase
                ),
                addFoodItemUseCase: addFoodItemUseCase,
                viewFoodInventoryUseCase: viewFoodInventoryUseCase,
                markFoodAsConsumedUseCase: markFoodAsConsumedUseCase,
                findExpiringFoodUseCase: findExpiringFoodUseCase)
            
            
            //            VStack (spacing: 24){
            //                Spacer()
            //
            //                Image (systemName: "leaf.circle.fill")
            //                    .font(.system(size: 80))
            //
            //                Text("FreshTrack")
            //                    .font(.largeTitle)
            //                    .fontWeight(.bold)
            //
            //                Text("Track your food and use it before it expires.")
            //                    .font(.headline)
            //                    .multilineTextAlignment(.center)
            //
            //                Spacer()
            //
            //                NavigationLink{
            //                    FoodListView(
            //                        viewModel: FoodListViewModel(viewFoodInventoryUseCase: viewFoodInventoryUseCase),
            //                        markFoodAsConsumedUseCase : markFoodAsConsumedUseCase
            //                    )
            //                } label:{
            //                    Label("My food", systemImage: "refrigerator")
            //                        .font(.headline)
            //                        .frame(maxWidth: .infinity)
            //                        .padding()
            //                }
            //                .buttonStyle(.borderedProminent)
            //
            //                Spacer()
            //
            //                NavigationLink{
            //                    AddFoodView(viewModel: AddFoodViewModel(addFoodItemUseCase: addFoodItemUseCase))
            //                } label: {
            //                    Label("Add Food", systemImage: "plus.circle.fill")
            //                        .font(.headline)
            //                        .frame(maxWidth: .infinity)
            //                        .padding()
            //                }
            //                .buttonStyle(.borderedProminent)
            //                Spacer()
            //
            //                NavigationLink{
            //                    ExpiringSoonView(viewModel: ExpiringSoonViewModel(findExpiringFoodUseCase: findExpiringFoodUseCase))
            //                } label: {
            //                    Label("Expiring Soon", systemImage: "clock.badge.exclamationmark")
            //                        .font(.headline)
            //                        .frame(maxWidth: .infinity)
            //                        .padding()
            //                }
            //                .buttonStyle(.bordered)
            //            }
            //            .padding()
            //            .navigationTitle("FreshTrack")
            
        }
    }
    
    
    //#Preview {
    //    ContentView()
    //}
}
