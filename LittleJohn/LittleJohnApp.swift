//
//  String+.swift
//  LittleJohn
//
//  Created by DispatchSwift on 2/19/22.
//

import SwiftUI

@main
struct LittleJohnApp: App {
	var body: some Scene {
		WindowGroup {
			SymbolListView(model: LJViewModel())
		}
	}
}
