import Foundation

class PluginManagerScanner {
	// property fields
	private var csvFileName: String
	private var plugins: [Triplet<String>]
	private var demoData: PluginManagerDemoData
	private var utils: PluginManagerScannerUtils
	
	init() {
		csvFileName = ""
		plugins = []
		demoData = PluginManagerDemoData()
		utils = PluginManagerScannerUtils()
	}

	func getPlugins() -> [Triplet<String>] {
		return plugins
	}

	func getCsvFileName() -> String {
		return csvFileName
	}
	
	func processPlugins(pluginType: String) {
		// cater for when PluginManagerScanner is run without the front-end UI
		var pluginType = ensureDefaultIfEmpty(pluginType: pluginType, defaultType: "CLAP")
		// check for DEMO plugin type
		if pluginType == "DEMO" {
			plugins = demoData.getDemoData()
		} else {
			// use upper case for plugin folder
			let pluginFolder = "/Library/Audio/Plug-Ins" + "/" + pluginType + "/"
			// then switch to lower case
			pluginType = pluginType.lowercased()
			// build list of plugin triplets
			plugins = buildPluginTriplets(pluginType: pluginType, pluginFolder: pluginFolder)
			// Sort the plugin triplets
			plugins = utils.sortPluginTripletsByManufacturerAndPlugin(plugins: plugins)
			// Print the plugins to the console
			printPluginsToConsole(plugins: plugins)
		}
	}
	
	private func ensureDefaultIfEmpty(pluginType: String, defaultType: String) -> String {
		var pluginType = pluginType
		if pluginType.isEmpty {
			pluginType = defaultType
		}
		return pluginType
	}
	
	private func buildPluginTriplets(pluginType: String, pluginFolder: String) -> [Triplet<String>] {
		let startPath = URL(fileURLWithPath: pluginFolder)
		var plugins = [Triplet<String>]()
		var paths = [URL]()
		do {
			try buildPListFileList(startPath: startPath, paths: &paths)
			// Process the files
			for file in paths {
				// This build the `paths` list of Manufacturer, Ident, Plugin Triplets
				processOnePListFile(pluginType: pluginType, pluginFolder: pluginFolder, plugins: &plugins, file: file)
			}
		} catch {
			print(error)
		}
		return plugins
	}
	
	private func sortPluginTripletsByManufacturer(plugins:consuming [Triplet<String>]) -> [Triplet<String>] {
		var mutPlugins = plugins
		mutPlugins.sort { $0.p0 < $1.p0 }
		return mutPlugins
	}
	
	private func printPluginsToConsole(plugins: [Triplet<String>]) {
		for plugin in plugins {
			print("\(plugin.p0) - \(plugin.p1) - \(plugin.p2)")
		}
	}
	
	private func processOnePListFile(pluginType: String, pluginFolder: String, plugins: inout [Triplet<String>], file: URL) {
		var plugin = file.path.replacingOccurrences(of: pluginFolder, with: "")
		plugin = plugin.replacingOccurrences(of: "." + pluginType + "/Contents/Info.plist", with: "")
		plugin = plugin + "." + pluginType
		// Open plist file as XML
		do {
			let data = try Data(contentsOf: file)
			let doc = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String: Any]
			// Extract the CFBundleIdentifier key-value pair
			if let ident = doc["CFBundleIdentifier"] as? String {
				let manufacturer = utils.createManufacturer(ident: ident, plugin: plugin, pluginType: pluginType)
				plugins.append(Triplet<String>(p0: manufacturer.lowercased(), p1: ident, p2: plugin))
			}
		} catch {
			print(error)
		}
	}
	
	private func buildPListFileList(startPath: URL, paths: inout [URL]) throws {
		let fileManager = FileManager.default
		let enumerator = fileManager.enumerator(at: startPath, includingPropertiesForKeys: nil)
		while let file = enumerator?.nextObject() as? URL {
			if !file.path.contains(".bundle") && file.pathExtension == "plist" {
				paths.append(file)
			}
		}
	}
	
	func getPluginsByManufacturer(plugins: [String]) -> [String: [String]] {
		var pluginsByManufacturer = [String: [String]]()
		for plugin in plugins {
			let parts = plugin.components(separatedBy: " - ")
			let manufacturer = parts[0]
			let ident = parts[1]
			let pluginName = parts[2]
			if pluginsByManufacturer[manufacturer] == nil {
				pluginsByManufacturer[manufacturer] = [String]()
			}
			pluginsByManufacturer[manufacturer]?.append("\(ident) - \(pluginName)")
		}
		return pluginsByManufacturer
	}
}


