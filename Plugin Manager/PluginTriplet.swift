import SwiftUI

struct PluginTriplet<T: Hashable>: Hashable, Identifiable {
	var manufacturer: T
	var plugin: T
	var ident: T
	let id = UUID()
}
