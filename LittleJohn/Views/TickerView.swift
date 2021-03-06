/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

/// Displays a list of stocks and shows live price updates.
struct TickerView: View {
  let selectedSymbols: [String]
	
	@EnvironmentObject var model: LJViewModel
  @Environment(\.presentationMode) var presentationMode

  @State var lastErrorMessage = "" {
    didSet {
			isDisplayingError = true
		}
  }
	
  @State var isDisplayingError = false

  var body: some View {
		List {
			Section {
				ForEach(model.tickerSymbols, id: \.name) { symbol in
					HStack {
						Text(symbol.name)
						Spacer()
						Text(String(format: "%.3f", [symbol.value]))
					}
				}
			} header: {
				Header(
					tile: "Live",
					imageName: "clock.arrow.2.circlepath",
					foregroundUIColor: .systemBlue
				)
			}
		}
		.alert("Error", isPresented: $isDisplayingError) {
			Button("Close", role: .cancel) { }
		} message: {
			Text(lastErrorMessage)
		}
		.listStyle(.plain)
		.font(.custom(LJTheme.font, size: 18))
		.padding(.horizontal)
		.task {
			do {
				try await model.startLiveTickerUpdates(selectedSymbols)
			} catch {
				// URLError from the ongoing URLSession that fetches the live updates.
				if let error = error as? URLError,
						error.code == .cancelled {
					return
				}
				
				lastErrorMessage = error.localizedDescription
			}
		}
		.onChange(of: model.tickerSymbols.count) { newValue in
			if newValue == 0 {
				presentationMode.wrappedValue.dismiss()
			}
		}
  }
}
