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
					let scanner = PluginManagerScanner()
					scanner.processPlugins(pluginType: selectedOption)
				}) {
					Text("Update")
				}
			}
			.padding()
			
			// Need a tree view here
			
			HStack {
				// TreeView
				let tree = TreeNode<String>(value: "Root", children: [
					TreeNode(value: "Child 1"),
					TreeNode(value: "Child 2", children: [
						TreeNode(value: "Grandchild 1"),
						TreeNode(value: "Grandchild 2")
					])
				])
				
				TreeView(node: tree) { item in
					Text(item)
				}
			}
			
			// need a multi-line memo box here and populate it with getPluginsAsText() from scanner
			
		}
	}
}
