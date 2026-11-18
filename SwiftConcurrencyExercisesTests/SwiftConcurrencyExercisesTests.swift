//
//  SwiftConcurrencyExercisesTests.swift
//  SwiftConcurrencyExercisesTests
//
//  Created by Liam on 17/11/2026.
//

@testable import SwiftConcurrencyExercises
import Testing

@MainActor
struct SwiftConcurrencyExercisesTests {

    @Test func scenarioA() async {
        let output = await ScenarioRunnerImpl().run(scenario: .scenarioA)

        let stages = output.stagesToRead
        #expect(stages.contains { $0 == .outletOpened(identifier: .wellington) })
        #expect(stages.contains { $0 == .outletOpened(identifier: .lowerHutt) })

        #expect(stages.contains { $0 == .submitAdoptionRequestStart(cat: Cat(id: 0, name: "Binky"), identifier: .wellington) })
        #expect(stages.contains { $0 == .managerReceivedSubmitRequest(cat: Cat(id: 0, name: "Binky")) })
        #expect(stages.contains { $0 == .submitAdoptionRequestEnd(cat: Cat(id: 0, name: "Binky"), identifier: .wellington) })
        #expect(stages.contains { $0 == .removeAdoptionRequestStart(cat: Cat(id: 0, name: "Binky"), identifier: .wellington) })
        #expect(stages.contains { $0 == .managerReceivedRemoveRequest(cat: Cat(id: 0, name: "Binky")) })
        #expect(stages.contains { $0 == .removeAdoptionRequestEnd(cat: Cat(id: 0, name: "Binky"), identifier: .wellington) })

        #expect(stages.contains { $0 == .submitAdoptionRequestStart(cat: Cat(id: 3, name: "Dave"), identifier: .lowerHutt) })
        #expect(stages.contains { $0 == .managerReceivedSubmitRequest(cat: Cat(id: 3, name: "Dave")) })
        #expect(stages.contains { $0 == .submitAdoptionRequestEnd(cat: Cat(id: 3, name: "Dave"), identifier: .lowerHutt) })

        #expect(stages.contains { $0 == .submitAdoptionRequestStart(cat: Cat(id: 1, name: "Mr. Beans"), identifier: .wellington) })
        #expect(stages.contains { $0 == .managerReceivedSubmitRequest(cat: Cat(id: 1, name: "Mr. Beans")) })
        #expect(stages.contains { $0 == .submitAdoptionRequestEnd(cat: Cat(id: 1, name: "Mr. Beans"), identifier: .wellington) })

        #expect(stages.contains { $0 == .submitAdoptionRequestStart(cat: Cat(id: 4, name: "Marty"), identifier: .lowerHutt) })
        #expect(stages.contains { $0 == .managerReceivedSubmitRequest(cat: Cat(id: 4, name: "Marty")) })
        #expect(stages.contains { $0 == .submitAdoptionRequestEnd(cat: Cat(id: 4, name: "Marty"), identifier: .lowerHutt) })
    }

    @Test func scenarioB() async {
        let output = await ScenarioRunnerImpl().run(scenario: .scenarioB)

        let stages = output.stagesToRead
        #expect(stages.contains { $0 == .outletOpened(identifier: .wellington) })
        #expect(stages.contains { $0 == .outletOpened(identifier: .lowerHutt) })

        #expect(stages.contains { $0 == .submitAdoptionRequestStart(cat: Cat(id: 0, name: "Binky"), identifier: .wellington) })
        #expect(stages.contains { $0 == .managerReceivedSubmitRequest(cat: Cat(id: 0, name: "Binky")) })
        #expect(stages.contains { $0 == .submitAdoptionRequestEnd(cat: Cat(id: 0, name: "Binky"), identifier: .wellington) })

        #expect(stages.contains { $0 == .submitAdoptionRequestStart(cat: Cat(id: 3, name: "Dave"), identifier: .lowerHutt) })
        #expect(stages.contains { $0 == .managerReceivedSubmitRequest(cat: Cat(id: 3, name: "Dave")) })
        #expect(stages.contains { $0 == .submitAdoptionRequestEnd(cat: Cat(id: 3, name: "Dave"), identifier: .lowerHutt) })
    }

    @Test func scenarioC() async {
        let output = await ScenarioRunnerImpl().run(scenario: .scenarioC)

        let stages = output.stagesToRead
        #expect(stages.contains { $0 == .outletOpened(identifier: .wellington) })
        #expect(stages.contains { $0 == .outletOpened(identifier: .lowerHutt) })

        #expect(stages.contains { $0 == .submitAdoptionRequestStart(cat: Cat(id: 0, name: "Binky"), identifier: .wellington) })
        #expect(stages.contains { $0 == .managerReceivedSubmitRequest(cat: Cat(id: 0, name: "Binky")) })
        #expect(stages.contains { $0 == .submitAdoptionRequestEnd(cat: Cat(id: 0, name: "Binky"), identifier: .wellington) })

        #expect(stages.contains { $0 == .submitAdoptionRequestStart(cat: Cat(id: 3, name: "Dave"), identifier: .lowerHutt) })
        #expect(stages.contains { $0 == .managerReceivedSubmitRequest(cat: Cat(id: 3, name: "Dave")) })
        #expect(stages.contains { $0 == .submitAdoptionRequestEnd(cat: Cat(id: 3, name: "Dave"), identifier: .lowerHutt) })
    }
    
}
