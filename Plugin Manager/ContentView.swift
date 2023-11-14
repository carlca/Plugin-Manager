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
					
					Text(" Manufacturer ")
						.font(.custom(gridFontName, size: 14, relativeTo: .body))
						.frame(maxWidth: maxManufacturerWidth, alignment: .leading)
						.background(Color.gray.opacity(0.3))
					Text(" Plugin ")
						.font(.custom(gridFontName, size: 14, relativeTo: .body))
						.frame(maxWidth: maxManufacturerWidth == 0 ? maxManufacturerWidth : .infinity, alignment: .leading)
						.background(Color.gray.opacity(0.3))
						.padding(.trailing, 8)
				}
//				.alignmentGuide(VerticalAlignment.center, computeValue: { d in d[VerticalAlignment.center] })
				.frame(width: geometry.size.width) // , alignment: .center)
				ScrollView {
					ScrollViewReader { value in
						LazyVGrid(columns: columns, spacing: 3) {
							ForEach(plugins, id: \.self) { plugin in
								Text(plugin.manufacturer)
									.font(.custom(gridFontName, size: 14, relativeTo: .body))
									.frame(maxWidth: maxManufacturerWidth, alignment: .leading)
									.alignmentGuide(.leading) { d in d[.leading] }
								Text(plugin.plugin)
									.font(.custom(gridFontName, size: 14, relativeTo: .body))
									.frame(maxWidth: .infinity, alignment: .leading)
									.alignmentGuide(.leading) { d in d[.leading] }
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
