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
        VStack(spacing: 32) {
            scenarioButton(.scenarioA)
            scenarioButton(.scenarioB)
        }
        .padding()
    }

    private func scenarioButton(_ scenario: AdoptionScenario) -> some View {
        Button(scenario.description) {
            Task {
                await viewModel.start(scenario: scenario)
            }
        }
    }
}

#Preview {
    ContentView(
        viewModel: ContentViewModelMock()
    )
}
