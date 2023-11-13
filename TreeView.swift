//
//  TreeView.swift
//  Plugin Manager
//
//  Created by Carl Caulkett on 13/11/2023.
//

import SwiftUI

struct TreeNode<T: Hashable> {
	let value: T
	var children: [TreeNode]? = nil
}

struct TreeView<T: Hashable, Content>: View where Content: View {
	let node: TreeNode<T>
	let content: (T) -> Content

	var body: some View {
		DisclosureGroup(
			content: {
				if let children = node.children {
					ForEach(children, id: \.value) { child in
						TreeView(node: child, content: content)
					}
				}
			},
			label: {
				content(node.value)
			}
		)
	}
}
