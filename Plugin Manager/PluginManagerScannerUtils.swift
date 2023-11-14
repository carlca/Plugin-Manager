class PluginManagerScannerUtils {

	func sortPluginTripletsByManufacturerAndPlugin(plugins: inout [PluginTriplet<String>]) -> [PluginTriplet<String>] {
		plugins.sort {
		  ($0.manufacturer, $0.plugin) < ($1.manufacturer, $1.plugin)
		}
		return plugins
	}
	
	func createManufacturer(ident: String, plugin: String, pluginType: String) -> String {
		let map = getReplacementsMap(plugin: plugin, pluginType: pluginType);
		var manufacturer = ident;
		for (key, value) in map {
			manufacturer = manufacturer.replacingOccurrences(of: key, with: value, options: .regularExpression, range: nil)
		}
		manufacturer = String(manufacturer.dropLast());
		manufacturer = String(manufacturer.dropLast());
		if (manufacturer == "") {
			manufacturer = "com.native-instruments";
		}
		if !manufacturer.contains("w.a.production") {
    	if let dotRange = manufacturer.range(of: ".") {
        let dotPos = manufacturer.distance(from: manufacturer.startIndex, to: dotRange.lowerBound)
        if dotPos > 0 {
            manufacturer = String(manufacturer[..<dotRange.lowerBound])
        }
    	}
		}		
		manufacturer = self.checkSpecialCases(manufacturer: manufacturer, ident: ident, plugin: plugin);
		return manufacturer;
	}

	func indexOf(subString: String, string: String) -> Int {
		if let range = string.range(of: subString) {
			return string.distance(from: string.startIndex, to: range.lowerBound)
		}
		return -1
	}

	func getReplacementsMap(plugin: String, pluginType: String) -> [String: String] {
		var map = [String: String]()
		map[plugin.lowercased()] = "";  
		map[pluginType] = "";
		map["\\.\\."] = ".";
		map["uk\\.co\\."] = "";
		map["co\\.uk\\."] = "";
		map["jp\\.co\\."] = "";
		map["com\\."] = "";
		map["net\\."] = "";
		map["se\\."] = "";
		map["ch\\."] = "";
		map["org\\."] = "";
		map["ca\\."] = "";
		map["de\\."] = "";
		map["jp\\."] = "";
		map["ly\\."] = "";
		map["cn\\."] = "";
		map["maizesoft.msp"] = "samplescience"
		return map;
	}

	func checkSpecialCases(manufacturer: String, ident: String, plugin: String) -> String {
		if (manufacturer.contains("w.a.production") || plugin.contains("Dragonfly")) {
			return plugin;
		}
		if (
			ident.contains("kontrol") ||
			ident.contains("kontakt") ||
			ident.contains("phasis") ||
			ident.contains("supercharger") ||
			ident.contains("replika") ||
			ident.contains("reaktor") ||
			ident.contains("raum.fx") ||
			ident.contains("guitar rig") ||
			ident.contains("freak.fx.vst") ||
			ident.contains("flair.fx.vst") ||
			ident.contains("fm8.fx.vst") ||
			ident.contains("fm8.synth.vst") ||
			ident.contains("choral") ||
			ident.contains("absynth")
		) {
			return "native instruments";
		}
		if (manufacturer.contains("Native-Instruments")) {
			return "native instruments";
		}
		if (manufacturer == "g") {
			return "gtune";
		}
		if (plugin == "Xhip" || plugin == "NeuralNote") {
			return plugin.lowercased();
		}
		if (plugin.contains("Odin2")) {
			return "the wave warden";
		}
		if (plugin.contains("Darvasa")) {
			return "igorski";
		}
		if (ident.contains(".korg.")) {
			return "korg"
		}
		return manufacturer
	}
	
	func stripLastCharacter(manufacturer: inout String) -> String {
		if (manufacturer.isEmpty) {
			return manufacturer;
		}
		// check if the manufacturer ends with a dot
		if (manufacturer.hasSuffix(".")) {
			manufacturer = String(manufacturer.dropLast());
		}
		return manufacturer;
	}

	


}

