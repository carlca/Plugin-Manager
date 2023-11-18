struct PluginTriplet<T: Hashable>: Hashable {
	var manufacturer: T
	var plugin: T
	var ident: T
	var index: Int?
}
