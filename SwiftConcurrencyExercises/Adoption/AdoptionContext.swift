//
//  AdoptionContext.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 25/09/2024.
//

enum AdoptionScenario: CustomStringConvertible {
    case scenarioA
    case scenarioB

    var description: String {
        switch self {
        case .scenarioA:
            "Scenario A"
        case .scenarioB:
            "Scenario B"
        }
    }
}

/// A class managing the cat adoption exercise context, hosting component instances and scenarios.
struct AdoptionContext: Sendable {

    private var adoptionManager: AdoptionManager!
    private var adoptionService: AdoptionService!

    private var wellington: AdoptionOutlet!
    private var lowerHutt: AdoptionOutlet!

    private let scenario: AdoptionScenario

    init(scenario: AdoptionScenario) {
        adoptionManager = AdoptionManager()
        adoptionService = AdoptionService()

        wellington = AdoptionOutlet(identifier: .wellington, adoptionManager: adoptionManager, adoptionService: adoptionService)
        lowerHutt = AdoptionOutlet(identifier: .lowerHutt, adoptionManager: adoptionManager, adoptionService: adoptionService)

        self.scenario = scenario
    }

    @MainActor
    func start() async {
        // Collect tasks to open each outlet (loading each one with results from a service)
        // such that the method continues after all outlets have opened.
        //
        // The group tasks can be `@MainActor` but the service calls within should be able to
        // switch actor context.
        await withDiscardingTaskGroup { group in
            group.addTask { @MainActor @Sendable in await self.wellington.open() }
            group.addTask { @MainActor @Sendable in await self.lowerHutt.open() }
        }
        print("All outlets opened\n")

        switch scenario {
        case .scenarioA:
            await scenarioA()
        case .scenarioB:
            await scenarioB()
        }
    }

    /// In this scenario, two sequences of adoption request submissions and removals are started at
    /// the same time. The expectation is that the adoption manager, being an actor, will neatly
    /// process the updates one at a time, meaning its underlying storage is never simultaneously
    /// accessed. We expect to see that the logs will appear such that updates within the adoption
    /// manager are immediately followed by an indication of the update ending.
    @MainActor
    private func scenarioA() async {
        // This could also be done as two unstructured `Task`s, but doing it like this allows us
        // to be aware when all tasks have been completed and run code after (e.g. a confirmation log.)
        await withDiscardingTaskGroup { group in
            group.addTask { @MainActor @Sendable in
                await self.wellington.submitAdoptionRequest(forCatWithID: 0)
                await self.wellington.submitAdoptionRequest(forCatWithID: 1)
                await self.wellington.removeAdoptionRequest(forCatWithID: 0)
            }

            group.addTask { @MainActor @Sendable in
                await self.lowerHutt.submitAdoptionRequest(forCatWithID: 3)
                await self.lowerHutt.submitAdoptionRequest(forCatWithID: 4)
            }
        }
        await print(adoptionManager.adoptionRequestCounts)
    }

    /// In this scenario, two sequences of adoption request submissions and removals are started at
    /// the same time. However, unlike scenario A, the adoption manager will await on some random delay
    /// before processing each update, meaning it will try and process as much of the next update as
    /// possible, if one exists. This setting means we will likely see logs that show the manager
    /// stacking updates, instead of processing them as units like in scenario A.
    @MainActor
    private func scenarioB() async {
        // By adding tasks to wait on before updating the manager's underlying storage, we open up the manager
        // actor to exhibit its non-atomicity property. When the manager reaches the suspension point for the
        // delay within one of the tasks below, the other will be attempted to be progressed until the delay
        // ends.
        await adoptionManager.setInduceRandomDelay()
        await withDiscardingTaskGroup { group in
            group.addTask { @MainActor @Sendable in
                await self.wellington.submitAdoptionRequest(forCatWithID: 0)
            }

            group.addTask { @MainActor @Sendable in
                await self.lowerHutt.submitAdoptionRequest(forCatWithID: 3)
            }
        }
        await print(adoptionManager.adoptionRequestCounts)
    }

}
