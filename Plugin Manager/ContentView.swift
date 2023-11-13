//
//  ContentView.swift
//  Plugin Manager
//
//  Created by Carl Caulkett on 10/11/2023.
//

import SwiftUI

struct ContentView: View {
	@State private var selectedOption = "VST"
	@State private var pluginsText = "Plugin 1\nPlugin 2"
	@State private var gridFontName = "Monaco"
	
	var body: some View {
		let columns = [
			GridItem(.flexible(), spacing: 60),
			GridItem(.flexible(), spacing: 60),
			GridItem(.flexible(), spacing: 60)
		]
		
		GeometryReader { geometry in
			VStack {
				HStack {
					Picker("  Options", selection: $selectedOption) {
						Text("VST").tag("VST")
						Text("VST3").tag("VST3")
						Text("CLAP").tag("CLAP")
					}
					.pickerStyle(MenuPickerStyle())
					.frame(minWidth: 150, idealWidth: 150, maxWidth: 150, maxHeight: 23, alignment: .center)
					.padding(.top, 6)
					.padding(.bottom, 0)
					
					Button(action: {
						let scanner = PluginManagerScanner()
						scanner.processPlugins(pluginType: selectedOption)
						self.pluginsText = scanner.getPluginsAsText()
					}) {
						Text("Update")
					}
					.frame(minWidth: 150, idealWidth: 150, maxWidth: 150, maxHeight: 23, alignment: .center)
					.padding(.top, 6)
					.padding(.bottom, 0)
				}
				HStack {
					Spacer()
					
					Text(" Manufacturer")
						.font(.custom(gridFontName, size: 14, relativeTo: .body))
						.frame(maxWidth: .infinity, alignment: .leading)
						.background(Color.gray.opacity(0.3))
					Text(" Ident ")
						.font(.custom(gridFontName, size: 14, relativeTo: .body))
						.frame(maxWidth: .infinity, alignment: .leading)
						.background(Color.gray.opacity(0.3))
					Text(" Plugin ")
						.font(.custom(gridFontName, size: 14, relativeTo: .body))
						.frame(maxWidth: .infinity, alignment: .leading)
						.background(Color.gray.opacity(0.3))
				}
				.alignmentGuide(VerticalAlignment.center, computeValue: { d in d[VerticalAlignment.center] })
				.frame(width: geometry.size.width, alignment: .center)
//				TextEditor(text: $pluginsText)
//					.frame(maxWidth: .infinity, maxHeight: .infinity)
//					.font(.custom("Monaco", size: 14, relativeTo: .body))
//					.multilineTextAlignment(.leading)
//					.lineSpacing(4.0)
				ScrollView {
					LazyVGrid(columns: columns, spacing: 3) {
						ForEach(0..<100) { _ in
							Text("Item")
								.font(.custom(gridFontName, size: 14, relativeTo: .body))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text("Item")
								.font(.custom(gridFontName, size: 14, relativeTo: .body))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text("Item")
								.font(.custom(gridFontName, size: 14, relativeTo: .body))
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					}
					.padding()
				}
			}
			.frame(width: geometry.size.width)
			.border(Color.black)
		}
	}
}
