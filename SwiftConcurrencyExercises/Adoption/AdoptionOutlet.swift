//
//  AdoptionOutlet.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 25/09/2024.
//

// This is implemented as an actor in order for outlets to participate in concurrent operations
// safely (i.e. be Sendable) but also manage internal state.
actor AdoptionOutlet {

    enum Identifier: Int {
        case wellington, lowerHutt
    }

    private let identifier: Identifier
    private let adoptionManager: AdoptionManager
    private let adoptionService: AdoptionService
    private var cats: [Cat] = []

    init(identifier: Identifier, adoptionManager: AdoptionManager, adoptionService: AdoptionService) {
        self.identifier = identifier
        self.adoptionManager = adoptionManager
        self.adoptionService = adoptionService
    }

    func open() async -> [ContextOutput.Stage] {
        cats = await adoptionService.fetchCats(forOutletWithIdentifier: identifier)
        print("Outlet opened with ID: \(identifier)")
        return [.outletOpened(identifier: identifier)]
    }

    func submitAdoptionRequest(forCatWithID id: Int) async -> [ContextOutput.Stage] {
        var stages: [ContextOutput.Stage] = []
        guard let cat = cats.first(where: { $0.id == id }) else {
            return stages
        }
        print("Start: Adoption request submitted for \(cat) from outlet with ID: \(identifier)")
        stages.append(.submitAdoptionRequestStart(cat: cat, identifier: identifier))
        stages.append(contentsOf: await adoptionManager.submitAdoptionRequest(for: cat))
        print("End: Adoption request submitted for \(cat) from outlet with ID: \(identifier)\n")
        stages.append(.submitAdoptionRequestEnd(cat: cat, identifier: identifier))
        return stages
    }

    func removeAdoptionRequest(forCatWithID id: Int) async -> [ContextOutput.Stage] {
        var stages: [ContextOutput.Stage] = []
        guard let cat = cats.first(where: { $0.id == id }) else {
            return stages
        }
        print("Start: Adoption request removed for \(cat) from outlet with ID: \(identifier)")
        stages.append(.removeAdoptionRequestStart(cat: cat, identifier: identifier))
        stages.append(contentsOf: await adoptionManager.removeAdoptionRequest(for: cat))
        print("End: Adoption request removed for \(cat) from outlet with ID: \(identifier)\n")
        stages.append(.removeAdoptionRequestEnd(cat: cat, identifier: identifier))
        return stages
    }

}

class AdoptionOutletNonAsync {

    private let identifier: AdoptionOutlet.Identifier
    private let adoptionManager: AdoptionManagerNonAsync
    private let adoptionService: AdoptionServiceNonAsync
    private var cats: [Cat] = []

    init(identifier: AdoptionOutlet.Identifier, adoptionManager: AdoptionManagerNonAsync, adoptionService: AdoptionServiceNonAsync) {
        self.identifier = identifier
        self.adoptionManager = adoptionManager
        self.adoptionService = adoptionService
    }

    func open() -> [ContextOutput.Stage] {
        cats = adoptionService.fetchCats(forOutletWithIdentifier: identifier)
        print("Outlet opened with ID: \(identifier)")
        return [.outletOpened(identifier: identifier)]
    }

    func submitAdoptionRequest(forCatWithID id: Int) -> [ContextOutput.Stage] {
        var stages: [ContextOutput.Stage] = []
        guard let cat = cats.first(where: { $0.id == id }) else {
            return stages
        }
        print("Start: Adoption request submitted for \(cat) from outlet with ID: \(identifier)")
        stages.append(.submitAdoptionRequestStart(cat: cat, identifier: identifier))
        stages.append(contentsOf: adoptionManager.submitAdoptionRequest(for: cat))
        print("End: Adoption request submitted for \(cat) from outlet with ID: \(identifier)\n")
        stages.append(.submitAdoptionRequestEnd(cat: cat, identifier: identifier))
        return stages
    }

    func removeAdoptionRequest(forCatWithID id: Int) -> [ContextOutput.Stage] {
        var stages: [ContextOutput.Stage] = []
        guard let cat = cats.first(where: { $0.id == id }) else {
            return stages
        }
        print("Start: Adoption request removed for \(cat) from outlet with ID: \(identifier)")
        stages.append(.removeAdoptionRequestStart(cat: cat, identifier: identifier))
        stages.append(contentsOf: adoptionManager.removeAdoptionRequest(for: cat))
        print("End: Adoption request removed for \(cat) from outlet with ID: \(identifier)\n")
        stages.append(.removeAdoptionRequestEnd(cat: cat, identifier: identifier))
        return stages
    }


}
