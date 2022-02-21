//
//  Constants.swift
//  LittleJohn
//
//  Created by DispatchSwift on 2/20/22.
//

import SwiftUI

struct Header: View {
	var tile: String
	var imageName: String
	var foregroundUIColor: UIColor
	
	var body: some View {
		Label(tile, systemImage: imageName)
			.foregroundColor(Color(uiColor: foregroundUIColor))
			.font(.custom("FantasqueSansMono-Regular", size: 34))
			.padding(.bottom, 20)
	}
}
