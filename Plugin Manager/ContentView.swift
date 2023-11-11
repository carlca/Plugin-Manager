//
//  ContentView.swift
//  Plugin Manager
//
//  Created by Carl Caulkett on 10/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedOption = "VST"
    
    var body: some View {
        VStack {
            // Top panel
            HStack {
                // Combo box
                Picker("Options", selection: $selectedOption) {
                    Text("VST").tag("VST")
                    Text("VST3").tag("VST3")
                    Text("CLAP").tag("CLAP")
                }
                .pickerStyle(MenuPickerStyle())
                
                // Button
                Button(action: {
                    // Handle button tap
                }) {
                    Text("Button")
                }
            }
            .padding()
            
            // Grid table
            List {
                DisclosureGroup("Tree Data", content: {
                    // Tree data structure content
                    Text("Tree Data 1")
                    Text("Tree Data 2")
                    Text("Tree Data 3")
                })
            }
            //.listStyle(InsetGroupedListStyle())
            
            Spacer()
        }
    }
}
