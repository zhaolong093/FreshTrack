//
//  AddFood.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import SwiftUI

struct AddFoodView: View {
    @StateObject private var viewModel: AddFoodViewModel
    
    init(viewModel: AddFoodViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            //MARK: Food Details
            
            Section("Food Details"){
                TextField("Food name", text: $viewModel.foodName)
                    .textInputAutocapitalization(.words)
                
                Stepper("Quantity: \(viewModel.quantity)", value: $viewModel.quantity, in: 1...99)
            }
            
            //MARK: Dates
            Section("Dates"){
                DatePicker("Purchase Date", selection: $viewModel.purchaseDate, displayedComponents: .date)
                
                DatePicker("Expiry Date", selection: $viewModel.expiryDate, displayedComponents: .date)
            }
            
            //MARK: Storage Location
            Section("Storage Location") {
                Picker("Location", selection: $viewModel.selectedStorageLocation){
                    Text("Select a location")
                        .tag(Optional<StorageLocation>.none)
                    
                    ForEach(StorageLocation.defaultlocations){
                        location in
                        Text(location.name).tag(Optional(location))
                    }
                }
            }
            
            //MARK: SAve
            Section{
                Button{ viewModel.saveFood()} label: {
                    Text("Save Food")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
            }
        }
        .navigationTitle("Add Food")
        .alert("Unable to Save Food", isPresented: $viewModel.showingError){
            Button("OK", role: .cancel){}
        } message:{
            Text(viewModel.errorMessage ?? "Something went wrong")
        }
        .alert("Food Added", isPresented: $viewModel.didSaveFood)
        {
            Button("OK", role: .cancel){}
        } message: {
            Text("The food item has been added to FreshTrack")
        }
    }
}
