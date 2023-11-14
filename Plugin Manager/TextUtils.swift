//
//  TextUtils.swift
//  SwiftLib
//
//  Created by Carl Caulkett on 14/11/2023.
//

import Foundation
import SwiftUI

public class TextUtils {
	
	class func textSize(text: String, fontName: String, size: CGFloat) -> CGFloat {
		let font = NSFont(name: fontName, size: size)
		let size: CGSize = text.size(withAttributes: [.font: font ?? NSFont.systemFont(ofSize: 14)])
		return size.width
	}
}
