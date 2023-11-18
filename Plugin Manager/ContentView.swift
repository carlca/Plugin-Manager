//
//  ContentView.swift
//  Plugin Manager
//
//  Created by Carl Caulkett on 10/11/2023.
//

import SwiftUI
import Combine

class TextFieldObserver: ObservableObject {
	@Published var filterText = ""
}

func hexToColor(hex: String) -> Color? {
	guard hex.count == 6,
				let red = Int(hex.prefix(2), radix: 16),
				let green = Int(hex.dropFirst(2).prefix(2), radix: 16),
				let blue = Int(hex.dropFirst(4), radix: 16) else {
		return nil
	}
	return Color(
		red: Double(red) / 255.0,
		green: Double(green) / 255.0,
		blue: Double(blue) / 255.0
	)
}

struct ContentView: View {
	@State private var selectedOption = "VST"
	@State private var plugins: [PluginTriplet<String>] = []
	@State private var gridFontName = "Monaco"
	@State private var maxManufacturerWidth: CGFloat = 0
	@State private var maxManufacturerLength: Int = 0
	@State private var maxPluginLength: Int = 0
	@State private var currentPlugin: PluginTriplet<String>? = nil
	@State private var pluginDict = [Int: PluginTriplet<String>]()
	@StateObject private var filterObserver = TextFieldObserver()
	
	var body: some View {
		GeometryReader { geometry in
			VStack {
				displayTopRowControls()
				displayColumnHeaders()
				displayPluginGrid()
			}
		}
	}

	func displayTopRowControls() -> some View {
		return HStack {
			displayPluginTypePicker()
			displayUpdateButton()
			displayFilter()
			Spacer()
		}
	}
	
	func displayPluginTypePicker()-> some View {
		return Picker("  Options", selection: $selectedOption) {
			Text("VST").tag("VST")
			Text("VST3").tag("VST3")
			Text("CLAP").tag("CLAP")
			Text("DEMO").tag("DEMO")
		}
		.pickerStyle(MenuPickerStyle())
		.frame(minWidth: 150, idealWidth: 150, maxWidth: 150, maxHeight: 23, alignment: .center)
		.padding(.top, 6)
		.padding(.bottom, 0)
	}
	
	func displayUpdateButton() -> some View {
		return Button(action: {
			let scanner = PluginManagerScanner()
			scanner.processPlugins(pluginType: selectedOption)
			self.plugins = scanner.getPlugins()
			maxManufacturerWidth = 0
			// Find the longest manufacturer and plugin names
			for plugin in self.plugins {
				let manufacturerWidth: CGFloat = TextUtils.textSize(text: plugin.manufacturer, fontName: "Monaco", size: 14)
				maxManufacturerWidth = max(maxManufacturerWidth, manufacturerWidth)
				maxManufacturerLength = max(maxManufacturerLength, plugin.manufacturer.count)
				maxPluginLength = max(maxPluginLength, plugin.plugin.count)
			}
		}) {
			Text("Update")
		}
		.frame(minWidth: 150, idealWidth: 150, maxWidth: 150, maxHeight: 23, alignment: .center)
		.padding(.top, 6)
		.padding(.bottom, 0)
	}
	
	func displayFilter() -> some View {
		return TextField("Filter", text: $filterObserver.filterText)
			.padding(.top, 6)
			.onReceive(filterObserver.$filterText) { newValue in
				pluginDict = createPluginDictionary(plugins: plugins)
			}
	}
	
	func displayPluginGrid() -> some View {
		return HStack {
			ScrollView {
				ScrollViewReader { scrollView in
					displayPluginGridInternal()
				}
			}
			Spacer()
		}
	}
	
	func displayPluginGridInternal() -> some View {
		return Grid(alignment: .leading) {
			// let pluginIndex = 0
			ForEach(plugins, id: \.self) { plugin in
				// Only display the row if no filter is active or if the plugin adheres to the filter
				if shouldPluginShow(plugin: plugin) {
					displayGridRow(plugin: plugin)
				}
			}
		}
	}
	
	func displayColumnHeaders() -> some View {
		return HStack {
			Spacer()
			Text(" Manufacturer ")
				.font(.custom(gridFontName, size: 14, relativeTo: .body))
				.frame(maxWidth: maxManufacturerWidth + 14, alignment: .leading)
				.background(Color.gray.opacity(0.3))
			Text(" Plugin " + filterObserver.filterText)
				.font(.custom(gridFontName, size: 14, relativeTo: .body))
				.frame(maxWidth: maxManufacturerWidth == 0 ? maxManufacturerWidth : .infinity, alignment: .leading)
				.background(Color.gray.opacity(0.3))
				.padding(.trailing, 8)
		}
	}
	
	func displayGridRow(plugin: PluginTriplet<String>) -> some View {
		let parts = plugin.plugin.split(separator: "/", maxSplits: 10)
		let manufacturerPad = String(repeating: " ", count: maxManufacturerLength - plugin.manufacturer.count)
		let pluginPad = String(repeating: " ", count: maxPluginLength - plugin.plugin.count + 1)
		return GridRow(alignment: .none) {
			// Display the Manufacturer name
			// manufacturerPad is used to pad the name to the width of the longest manufacturer name
			Text(plugin.manufacturer + manufacturerPad)
				.foregroundColor(.teal)
				.font(.custom(gridFontName, size: 14, relativeTo: .body))
				.frame(alignment: .leading)
				.padding(.leading, 17)
			HStack(spacing: 0) {
				// If no slashes then there is no sub-folder: just print the plugin name
				if parts.count == 1 {
					Text(String(parts[0]) + pluginPad)
						.foregroundColor(.teal)
						.font(.custom(gridFontName, size: 14, relativeTo: .body))
						.padding(.leading, 14)
				} else {
					// There are sub-folders
					// Build a color array
					let hexColors = ["FFFFFF", "CC99CC", "6699CC"]
					let colors: [Color] = hexColors.compactMap { hexToColor(hex: $0) }
					// Each sub-folder has a separate Text block
					HStack(spacing: 0) {
						let indices = parts.indices.dropLast()
						ForEach(indices, id: \.self) { index in
							let part = String(parts[index])
							// Use modulo operation to cycle through colors if there are more parts than colors
							let color = colors[index % colors.count]
							let text = Text(part + "/")
								.foregroundColor(color)
								.font(.custom(gridFontName, size: 14, relativeTo: .body))
							// Set the padding of the displayed sub-folder to 14 if it is the first part of the path, 0 otherwise
							let paddedText = text.padding(.leading, index == 0 ? 14 : 0)
							paddedText
						}
						// Grab the last part of the parts array. This is the plug filename itself
						// pluginPad is used to pad the name to the width of the longest plugin name + path
						let lastPart = String(parts.last ?? "") + pluginPad
						let lastPartText = Text(lastPart)
							.foregroundColor(.teal)
							.font(.custom(gridFontName, size: 14, relativeTo: .body))
						lastPartText
					}
				}
			}
		}
		//.background(plugin == pluginDict[pluginIndex] ? Color.yellow : Color.clear)
	}

	func createPluginDictionary(plugins: [PluginTriplet<String>]) -> [Int: PluginTriplet<String>] {
		var pluginDict = [Int: PluginTriplet<String>]()
		var pluginIndex = 0
		for plugin in plugins {
			if shouldPluginShow(plugin: plugin) {
				pluginDict[pluginIndex] = plugin
				pluginIndex += 1
			}
		}
		return pluginDict
	}

	func shouldPluginShow(plugin: PluginTriplet<String>) -> Bool {
		if filterObserver.filterText.isEmpty || plugin.manufacturer.lowercased().contains(filterObserver.filterText.lowercased()) ||
		plugin.plugin.lowercased().contains(filterObserver.filterText.lowercased()) {
			return true
		}
		return false
	}
}
