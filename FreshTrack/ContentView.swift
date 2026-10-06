//
//  ContentView.swift
//  FreshTrack
//
//  Created by 是她 on 2/10/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack (spacing: 24){
                Image (systemName: "leaf.circle.fill")
                    .font(.system(size: 80))
                
                Text("FreshTrack")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Track your food and use it before it expires.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Text("Your food dashbaord will appear here.")
                    .foregroundStyle(.secondary)
                
                
                Spacer()
            }
            .padding()
//            .navigationTitle("FreshTrack")
        }
    }
}


#Preview {
    ContentView()
}

