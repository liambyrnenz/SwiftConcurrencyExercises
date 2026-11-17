//
//  AdoptionContextNonAsync.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 26/07/2025.
//

import Dispatch

class AdoptionContextNonAsync {

    private let adoptionManager: AdoptionManagerNonAsync
    private let adoptionService: AdoptionServiceNonAsync

    private let wellington: AdoptionOutletNonAsync
    private let lowerHutt: AdoptionOutletNonAsync

    private let scenario: AdoptionScenario

    init(scenario: AdoptionScenario) {
        adoptionManager = AdoptionManagerNonAsync()
        adoptionService = AdoptionServiceNonAsync()

        wellington = AdoptionOutletNonAsync(identifier: .wellington, adoptionManager: adoptionManager, adoptionService: adoptionService)
        lowerHutt = AdoptionOutletNonAsync(identifier: .lowerHutt, adoptionManager: adoptionManager, adoptionService: adoptionService)

        self.scenario = scenario
    }

    func run() async -> ContextOutput {
        let output = ContextOutput()

        // Like in the modern async scenarios, two read operations are kicked off simultaneously here.
        // The manager used by the outlets manages concurrent access with a serial queue.
        DispatchQueue.global().async {
            output.add(stages: self.wellington.open())
        }
        DispatchQueue.global().async {
            output.add(stages: self.lowerHutt.open())
        }
        print("All outlets opened\n")

        switch scenario {
        case .scenarioC:
            await scenarioC(output: output)
        default:
            fatalError("Incompatible scenario")
        }

        return output
    }

    /// In this scenario, two adoption requests are started at the same time. The manager used by the outlets manages concurrent
    /// access with a serial queue. This should mean that the same order is achieved every time.
    private func scenarioC(output: ContextOutput) async {
        DispatchQueue.global().async {
            output.add(stages: self.wellington.submitAdoptionRequest(forCatWithID: 0))
        }
        DispatchQueue.global().async {
            output.add(stages: self.lowerHutt.submitAdoptionRequest(forCatWithID: 3))
        }
    }

}
