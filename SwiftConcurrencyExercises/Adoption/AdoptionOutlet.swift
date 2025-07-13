//
//  AdoptionOutlet.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 25/09/2024.
//

// This class marked as `@unchecked Sendable` is akin to a presenter implemented as a class in an
// MVP/VIPER architecture, thus showing how `@unchecked Sendable` is a way such components can be
// made to fit in an async/await context (albeit a bad one - ideally, some other way should be found
// to make this Sendable.)
class AdoptionOutlet: @unchecked Sendable {

    enum Identifier: Int {
        case wellington, lowerHutt
    }

    private let identifier: Identifier
    private let adoptionManager: AdoptionManager
    private let adoptionService: AdoptionService
    private(set) var cats: [Cat] = []

    required init(identifier: Identifier, adoptionManager: AdoptionManager, adoptionService: AdoptionService) {
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
