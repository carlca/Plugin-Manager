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
	@State private var pluginDict: [String: Int] = [:]
	@State private var pluginIndex: Int = 0
	@State private var firstVisibleRow: Int = 0
	@State private var lastVisibleRow: Int = 0
	@State private var scrollRequest: Int = 0
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
			pluginDict = createPluginDictionary(plugins: plugins)
			for plugin in self.plugins {
				let manufacturerWidth: CGFloat = TextUtils.textWidth(text: plugin.manufacturer, fontName: "Monaco", size: 14)
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
				pluginIndex = 0
			}
			.background {
				ZStack {
					Button("") {
						if pluginIndex < pluginDict.count {
							pluginIndex += 1
							if pluginIndex > lastVisibleRow {
								lastVisibleRow = pluginIndex
								firstVisibleRow += 1
								scrollRequest = 1				// SCROLL DOWN
							}
						}
					}
					.keyboardShortcut(KeyboardShortcut(.downArrow, modifiers: []))
					Button("") {
						if pluginIndex > 0 {
							pluginIndex -= 1
							if pluginIndex < firstVisibleRow {
								firstVisibleRow = pluginIndex
								lastVisibleRow -= 1
								scrollRequest = -1			// SCROLL UP
							}
						}
					}
					.keyboardShortcut(KeyboardShortcut(.upArrow, modifiers: []))
				}
				.opacity(0)
			}
	}
	
	func displayPluginGrid() -> some View {
		GeometryReader { geometry in
			HStack {
				ScrollViewReader { scrollView in
					ScrollView {
						displayPluginGridInternal()
					}
					.background(GeometryReader { proxy in
						Color.clear.onAppear {
						}
						.onChange(of: proxy.size) { newSize in
							updateVisibleRows(size: newSize.height)
						}
					}
					.onChange(of: scrollRequest) { newScrollRequest in
						if newScrollRequest != 0 {
							scrollRequest = 0
							let currentScrollPosition = geometry.frame(in: .global).minY
							let scrollOffset = CGFloat(newScrollRequest) * TextUtils.textHeight(text: "XXXX", fontName: "Monaco", size: 14)
							let newScrollPosition = currentScrollPosition + CGFloat(scrollOffset)
							scrollView.scrollTo(newScrollPosition, anchor: .top)
						}
					})
				}
				Spacer()
			}
			.background(GeometryReader { proxy in
				Color.clear.onAppear {
					// Additional background logic here
				}
			})
		}
	}
	
	func updateVisibleRows(size: CGFloat) {
		let visibleRowCount = getVisibleRowCount(size: size)
		lastVisibleRow = firstVisibleRow + visibleRowCount - 1
	}
	
	func getVisibleRowCount(size: CGFloat) -> Int {
		let rowHeight: CGFloat = TextUtils.textHeight(text: "XXXX", fontName: "Monaco", size: 14)
		return Int(floor(size / rowHeight))
	}

	func displayPluginGridInternal() -> some View {
		return Grid(alignment: .leading) {
			ForEach(plugins, id: \.self) { plugin in
				if shouldPluginShow(plugin: plugin) {
					displayGridRow(plugin: plugin)
				}
			}
		}
	}
	
	func displayColumnHeaders() -> some View {
		return HStack {
			if plugins.count > 0 {
				Spacer()
				Text(" Manufacturer ")
					.font(.custom(gridFontName, size: 14, relativeTo: .body))
					.frame(maxWidth: maxManufacturerWidth + 16, alignment: .leading)
					.background(Color.gray.opacity(0.3))
				
				Text(" Plugin " + "First: " + String(firstVisibleRow) + " Last: " + String(lastVisibleRow))
					.font(.custom(gridFontName, size: 14, relativeTo: .body))
					.frame(maxWidth: maxManufacturerWidth == 0 ? maxManufacturerWidth : .infinity, alignment: .leading)
					.background(Color.gray.opacity(0.3))
					.padding(.trailing, 8)
			}
		}
	}
	
	func displayGridRow(plugin: PluginTriplet<String>) -> some View {
		return GridRow(alignment: .none) {
			Spacer().frame(width: 8)
			displayManufacturerColumn(plugin: plugin)
			displayPluginColumn(plugin: plugin)
		}
	}
	
	func displayManufacturerColumn(plugin: PluginTriplet<String>) -> some View {
		let manufacturerPad = String(repeating: " ", count: maxManufacturerLength - plugin.manufacturer.count + 1)
		return Text(plugin.manufacturer + manufacturerPad)
			.foregroundColor(pluginDict[plugin.plugin] == pluginIndex ? Color.yellow : Color.teal)
			.font(.custom(gridFontName, size: 14, relativeTo: .body))
			.frame(maxWidth: maxManufacturerWidth + 6, alignment: .leading)
			.padding(.leading, 10)
			.background(pluginDict[plugin.plugin] == pluginIndex ? Color.accentColor : Color.clear)
	}
	
	func displayPluginColumn(plugin: PluginTriplet<String>) -> some View {
		let parts = plugin.plugin.split(separator: "/", maxSplits: 10)
		let pluginPad = String(repeating: " ", count: maxPluginLength - plugin.plugin.count + 1)
		return HStack(spacing: 0) {
			if parts.count == 1 {
				displayPluginNameOnly(plugin: plugin, parts: parts, pluginPad: pluginPad)
			} else {
				displaySubFoldersAndPlugin(plugin: plugin, parts: parts, pluginPad: pluginPad)
			}
		}
		.background(pluginDict[plugin.plugin] == pluginIndex ? Color.accentColor : Color.clear)
	}
	
	func displayPluginNameOnly(plugin: PluginTriplet<String>, parts: [Substring], pluginPad: String) -> some View {
		return Text(String(parts[0]) + pluginPad)
			.foregroundColor(pluginDict[plugin.plugin] == pluginIndex ? Color.yellow : .teal)
			.font(.custom(gridFontName, size: 14, relativeTo: .body))
			.padding(.leading, 8)
	}
	
	func displaySubFoldersAndPlugin(plugin: PluginTriplet<String>, parts: [Substring], pluginPad: String) -> some View {
		return HStack(spacing: 0) {
			let indices = parts.indices.dropLast()
			ForEach(indices, id: \.self) { index in
				displayOneSubFolder(plugin: plugin, parts: parts, index: index)
			}
			displayPluginFileName(plugin: plugin, parts: parts, pluginPad: pluginPad)
		}
	}
	
	func displayOneSubFolder(plugin: PluginTriplet<String>, parts: [Substring], index: Int) -> some View {
		let part = String(parts[index])
		let color = getSubFolderColor(parts: parts, index: index)
		let text = Text(part + "/")
			.foregroundColor(pluginDict[plugin.plugin] == pluginIndex ? Color.yellow : color)
			.font(.custom(gridFontName, size: 14, relativeTo: .body))
		// Set the padding of the displayed sub-folder to 8 if it is the first part of the path, 0 otherwise
		let paddedText = text.padding(.leading, index == 0 ? 8 : 0)
		return paddedText
	}
	
	func displayPluginFileName(plugin: PluginTriplet<String>, parts: [Substring], pluginPad: String) -> some View {
		let lastPart = String(parts.last ?? "") + pluginPad
		let lastPartText = Text(lastPart)
			.foregroundColor(pluginDict[plugin.plugin] == pluginIndex ? Color.yellow : .teal)
			.font(.custom(gridFontName, size: 14, relativeTo: .body))
		return lastPartText
	}
	
	func getSubFolderColor(parts: [Substring], index: Int) -> Color {
		let hexColors = ["FFFFFF", "CC99CC", "6699CC"]
		let colors: [Color] = hexColors.compactMap { hexToColor(hex: $0) }
		return colors[index % colors.count]
	}
	
	func createPluginDictionary(plugins: [PluginTriplet<String>]) -> [String: Int] {
		var pluginDict = [String: Int]()
		var pluginIndex = 0
		for plugin in plugins {
			if shouldPluginShow(plugin: plugin) {
				pluginDict[plugin.plugin] = pluginIndex
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

