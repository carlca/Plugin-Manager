//
//  ContentView.swift
//  Plugin Manager
//
//  Created by Carl Caulkett on 10/11/2023.
//

import SwiftUI

struct ContentView: View {
	@State private var selectedOption = "VST"
	@State private var plugins: [PluginTriplet<String>] = []
	@State private var gridFontName = "Monaco"
	@State private var maxManufacturerWidth: CGFloat = 0
	@State private var longestManufacturer: String = ""
	
	var body: some View {
		let columns = [
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
						Text("DEMO").tag("DEMO")
					}
					.pickerStyle(MenuPickerStyle())
					.frame(minWidth: 150, idealWidth: 150, maxWidth: 150, maxHeight: 23, alignment: .center)
					.padding(.top, 6)
					.padding(.bottom, 0)
					
					Button(action: {
						let scanner = PluginManagerScanner()
						scanner.processPlugins(pluginType: selectedOption)
						self.plugins = scanner.getPlugins()
						maxManufacturerWidth = 0
						for plugin in self.plugins {
							let manufacturerWidth: CGFloat = TextUtils.textSize(text: plugin.manufacturer, fontName: "Monaco", size: 14)
							if manufacturerWidth > maxManufacturerWidth {
								maxManufacturerWidth = manufacturerWidth
								longestManufacturer = plugin.manufacturer
								print(plugin)
							}
						}
					}) {
						Text("Update")
					}
					.frame(minWidth: 150, idealWidth: 150, maxWidth: 150, maxHeight: 23, alignment: .center)
					.padding(.top, 6)
					.padding(.bottom, 0)
					Spacer()
				}
				HStack {
					Spacer()
					
					Text(" Manufacturer ") // CORRECT
						.font(.custom(gridFontName, size: 14, relativeTo: .body))
						.frame(maxWidth: maxManufacturerWidth + 14, alignment: .leading)
						.background(Color.gray.opacity(0.3))
					Text(" Plugin ")		// CORRECT
						.font(.custom(gridFontName, size: 14, relativeTo: .body))
						.frame(maxWidth: maxManufacturerWidth == 0 ? maxManufacturerWidth : .infinity, alignment: .leading)
						.background(Color.gray.opacity(0.3))
						.padding(.trailing, 8)
				}

				.frame(width: geometry.size.width)
				ScrollView {
					ScrollViewReader { value in
						LazyVGrid(columns: columns, spacing: 3) {
							ForEach(plugins, id: \.self) { plugin in
								HStack {
									HStack {
										Text(plugin.manufacturer) // CORRECT
											.font(.custom(gridFontName, size: 14, relativeTo: .body))
											.frame(maxWidth: maxManufacturerWidth, alignment: .leading)
										Text(plugin.plugin)     // WRONG
											.font(.custom(gridFontName, size: 14, relativeTo: .body))
											.frame(maxWidth: .infinity, alignment: .leading)
									}
								}
								.frame(maxWidth: .infinity, alignment: .leading)
							}
						}
					}
					.padding(.leading, 16)
				}
			}
			.frame(width: geometry.size.width)
			.border(Color.black)
		}
	}
}
