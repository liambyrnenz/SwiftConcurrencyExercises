//
//  ScenarioRunner.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 18/09/2024.
//

@MainActor
protocol ScenarioRunner {
    func run(scenario: AdoptionScenario) async -> ContextOutput
}

struct ScenarioRunnerMock: ScenarioRunner {
    // Because this definition isn't making the compiler angry, it's assumed that its current form satisfies the
    // protocol requirements.
    //
    // The protocol states that implementers must be main actor isolated, so this is inferred to be `@MainActor`.
    // Actor-isolated methods are always accessed from a different actor context using `async`, so this is also
    // implicitly `async`.
    func run(scenario: AdoptionScenario) async -> ContextOutput { .init() }
}

class ScenarioRunnerImpl: ScenarioRunner {

    func run(scenario: AdoptionScenario) async -> ContextOutput {
        if scenario.isAsync {
            await AdoptionContext(scenario: scenario).run()
        } else {
            await AdoptionContextNonAsync(scenario: scenario).run()
        }
    }

}
