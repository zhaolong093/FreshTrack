//
//  ContentView.swift
//  FreshTrack
//
//  Created by 是她 on 2/10/2026.
//

import SwiftUI

struct ContentView: View {
    
    let addFoodItemUseCase: AddFoodItemUseCase
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 24){
                Spacer()
                
                Image (systemName: "leaf.circle.fill")
                    .font(.system(size: 80))
                
                Text("FreshTrack")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Track your food and use it before it expires.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                NavigationLink{
                    AddFoodView(viewModel: AddFoodViewModel(addFoodItemUseCase: addFoodItemUseCase))
                } label: {
                    Label("Add Food", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            .padding()
//            .navigationTitle("FreshTrack")
        }
    }
}


//#Preview {
//    ContentView()
//}

