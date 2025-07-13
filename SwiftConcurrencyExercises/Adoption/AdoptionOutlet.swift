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

    func open() async {
        cats = await adoptionService.fetchCats(forOutletWithIdentifier: identifier)
        print("Outlet opened with ID: \(identifier)")
    }

    func submitAdoptionRequest(forCatWithID id: Int) async {
        guard let cat = cats.first(where: { $0.id == id }) else {
            return
        }
        print("Start: Adoption request submitted for \(cat) from outlet with ID: \(identifier)")
        await adoptionManager.submitAdoptionRequest(for: cat)
        print("End: Adoption request submitted for \(cat) from outlet with ID: \(identifier)\n")
    }

    func removeAdoptionRequest(forCatWithID id: Int) async {
        guard let cat = cats.first(where: { $0.id == id }) else {
            return
        }
        print("Start: Adoption request removed for \(cat) from outlet with ID: \(identifier)")
        await adoptionManager.removeAdoptionRequest(for: cat)
        print("End: Adoption request removed for \(cat) from outlet with ID: \(identifier)\n")
    }

}
