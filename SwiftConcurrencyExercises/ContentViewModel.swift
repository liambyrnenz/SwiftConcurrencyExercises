//
//  ContentViewModel.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 18/09/2024.
//

// MARK: - ContentViewModel

@MainActor
protocol ContentViewModel {
    func start(scenario: AdoptionScenario) async
}

struct ContentViewModelMock: ContentViewModel {
    // Because this definition isn't making the compiler angry, it's assumed that its current form satisfies the
    // protocol requirements.
    //
    // The protocol states that implementers must be main actor isolated, so this is inferred to be `@MainActor`.
    // Actor-isolated methods are always accessed from a different actor context using `async`, so this is also
    // implicitly `async`.
    func start(scenario: AdoptionScenario) async {}
}

class ContentViewModelImpl: ContentViewModel {

    func start(scenario: AdoptionScenario) async {
        await AdoptionContext(scenario: scenario).start()
    }

}
