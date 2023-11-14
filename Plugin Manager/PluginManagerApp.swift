//
//  Plugin_ManagerApp.swift
//  Plugin Manager
//
//  Created by Carl Caulkett on 10/11/2023.
//

import SwiftUI

@main
struct PluginManagerApp: App {
	@Environment(\.scenePhase) private var scenePhase
	var body: some Scene {
		WindowGroup {
			ContentView().onChange(of: scenePhase) { phase in
				if phase == .active {
					NSApp.activate(ignoringOtherApps: true)
				}
			}
		}
	}
}

#Preview {
	ContentView()
}

var body: some Scene {
	WindowGroup {
		ContentView()
	}
}

