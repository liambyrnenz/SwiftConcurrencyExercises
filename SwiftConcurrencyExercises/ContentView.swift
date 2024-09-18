//
//  ContentView.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 18/09/2024.
//

import SwiftUI

struct ContentView: View {
    let viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Button("Start Concurrent Work!") {
                viewModel.start()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(
        viewModel: ContentViewModelMock()
    )
}
