class PluginManagerScannerUtils {

	func sortPluginTripletsByManufacturerAndPlugin(plugins: Array<Triplet<String>>) {
		var pluginsMut = plugins
		pluginsMut.sort { (a: Triplet<String>, b: Triplet<String>) in
			if a.part0 < b.part0() {
				return -1
			}
			if a.part0() > b.part0() {
				return 1
			}
			if a.part2() < b.part2() {
				return -1
			}
			if a.part2() > b.part2() {
				return 1
			}
			return 0
		}
	}
	
	func createManufacturer(ident: String, plugin: String, pluginType: Array<Triplet<String>>) {
		let map = self.getReplacementsMap(plugin, pluginType);
		var manufacturer = ident;
		for (key, value) in map {
			manufacturer = manufacturer.replacingOccurrences(of: key, with: value, options: .regularExpression, range: nil)
		}
		manufacturer = self.stripLastCharacter(manufacturer);
		manufacturer = self.stripLastCharacter(manufacturer);
		if (manufacturer === "") {
			manufacturer = "com.native-instruments";
		}
		if (!manufacturer.contains("w.a.production")) {
			let dotPos = manufacturer.indexOf(".");
			if (dotPos > 0) {
				manufacturer = manufacturer.substring(0, dotPos);
			}
		}
		manufacturer = self.checkSpecialCases(manufacturer, ident, plugin);
		return manufacturer;
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
		if (manufacturer === "g") {
			return "gtune";
		}
		if (plugin === "Xhip" || plugin === "NeuralNote") {
			return plugin.toLowerCase();
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
	
	func stripLastCharacter(manufacturer: String) {
		if (manufacturer.endsWith(".")) {
			manufacturer = manufacturer.substring(0, manufacturer.length - 1);
		}
		return manufacturer;
	}
}

