import Foundation

class PluginManagerScanner {
	// property fields
	private var csvFileName: String
	private var plugins: [PluginTriplet<String>]
	private var demoData: PluginManagerDemoData
	private var utils: PluginManagerScannerUtils
	
	init() {
		csvFileName = ""
		plugins = []
		demoData = PluginManagerDemoData()
		utils = PluginManagerScannerUtils()
	}

	func getPlugins() -> [PluginTriplet<String>] {
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
			plugins = utils.sortPluginTripletsByManufacturerAndPlugin(plugins: &plugins)
			// Print the plugins to the console
			printPluginsToConsole()
		}
	}

	func getPluginsAsText() -> String {
		var result: String = ""
		for plugin in plugins {
			result += "\(plugin.manufacturer) - \(plugin.plugin) - \(plugin.ident)\n"
		}
		return result
	}
	
	private func ensureDefaultIfEmpty(pluginType: String, defaultType: String) -> String {
		var pluginType = pluginType
		if pluginType.isEmpty {
			pluginType = defaultType
		}
		return pluginType
	}
	
	private func buildPluginTriplets(pluginType: String, pluginFolder: String) -> [PluginTriplet<String>] {
		let startPath = URL(fileURLWithPath: pluginFolder)
		var plugins = [PluginTriplet<String>]()
		var paths = [URL]()
		do {
			try buildPListFileList(startPath: startPath, paths: &paths)
			// Process the files
			for file in paths {
				// This build the `paths` list of Manufacturer, Plugin, Ident
				processOnePListFile(pluginType: pluginType, pluginFolder: pluginFolder, plugins: &plugins, file: file)
			}
		} catch {
			print(error)
		}
		return plugins
	}
	
	private func sortPluginTripletsByManufacturer(plugins:consuming [PluginTriplet<String>]) -> [PluginTriplet<String>] {
		var mutPlugins = plugins
		mutPlugins.sort { $0.manufacturer < $1.manufacturer }
		return mutPlugins
	}
	
	private func printPluginsToConsole() {
		print(getPluginsAsText())
	}
	
	private func processOnePListFile(pluginType: String, pluginFolder: String, plugins: inout [PluginTriplet<String>], file: URL) {
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
				plugins.append(PluginTriplet<String>(manufacturer: manufacturer.lowercased(), plugin: plugin, ident: ident))
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


