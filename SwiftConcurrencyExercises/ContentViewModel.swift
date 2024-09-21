//
//  ContentViewModel.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 18/09/2024.
//

// MARK: - ContentViewModel

protocol ContentViewModel {
    @MainActor func start() async
}

struct ContentViewModelMock: ContentViewModel {
    // Because this definition isn't making the compiler angry, it's assumed that its current form satisfies the
    // protocol requirements. 
    // 
    // The protocol states that members must be main actor isolated, so this is inferred to be `@MainActor`.
    // Actor-isolated methods are always accessed from a different actor context using `async`, so this is also 
    // implicitly `async`.
    func start() {}
}

class ContentViewModelImpl: ContentViewModel {
    
    private var adoptionManager: AdoptionManager!
    private var adoptionService: AdoptionService!
    
    private var wellington: AdoptionOutlet!
    private var lowerHutt: AdoptionOutlet!
    
    func setUp() {
        adoptionManager = AdoptionManager()
        adoptionService = AdoptionService()
        
        wellington = AdoptionOutlet(identifier: .wellington, adoptionManager: adoptionManager, adoptionService: adoptionService)
        lowerHutt = AdoptionOutlet(identifier: .lowerHutt, adoptionManager: adoptionManager, adoptionService: adoptionService)
    }
    
    func start() async {
        setUp()
        
        // Collect tasks to open each outlet (loading each one with results from a service)
        // such that the method continues after all outlets have opened.
        //
        // The group tasks can be `@MainActor` but the service calls within should be able to
        // switch actor context.
        await withDiscardingTaskGroup { group in
            group.addTask { @MainActor in await self.wellington.open() }
            group.addTask { @MainActor in await self.lowerHutt.open() }
        }
        print("All outlets opened\n")
        
        await scenarioA()
    }
    
    @MainActor
    private func scenarioA() async {
        // This could also be done as two unstructured `Task`s, but doing it like this allows us
        // to be aware when all tasks have been completed and run code after (e.g. a confirmation log.)
        await withDiscardingTaskGroup { group in
            group.addTask { @MainActor in
                await self.wellington.submitAdoptionRequest(forCatWithID: 0)
                await self.wellington.submitAdoptionRequest(forCatWithID: 1)
                await self.wellington.removeAdoptionRequest(forCatWithID: 0)
            }
            
            group.addTask { @MainActor in
                await self.lowerHutt.submitAdoptionRequest(forCatWithID: 3)
                await self.lowerHutt.submitAdoptionRequest(forCatWithID: 4)
            }
        }
        await print(adoptionManager.adoptionRequestCounts)
    }
    
}

// MARK: - AdoptionManager

struct Cat: Hashable {
    let id: Int
    let name: String
}

actor AdoptionManager {
    
    private(set) var adoptionRequestCounts: [Cat: Int] = [:]
    
    func submitAdoptionRequest(for cat: Cat) {
        print("AdoptionManager received submit adoption request for \(cat)")
        adoptionRequestCounts[cat, default: 0] += 1
    }
    
    func removeAdoptionRequest(for cat: Cat) {
        print("AdoptionManager received remove adoption request for \(cat)")
        adoptionRequestCounts[cat]? -= 1
        if adoptionRequestCounts[cat] == 0 {
            adoptionRequestCounts[cat] = nil
        }
    }
    
}

// MARK: - AdoptionService

class AdoptionService {
    
    func fetchCats(forOutletWithIdentifier identifier: AdoptionOutlet.Identifier) async -> [Cat] {
        await Task {
            await Task.randomDelay()

            switch identifier {
            case .wellington:
                return [
                    Cat(id: 0, name: "Binky"),
                    Cat(id: 1, name: "Mr. Beans"),
                    Cat(id: 2, name: "Snuggs")
                ]
            case .lowerHutt:
                return [
                    Cat(id: 3, name: "Dave"),
                    Cat(id: 4, name: "Marty")
                ]
            }
        }.value
    }
    
}

// MARK: - AdoptionOutlet

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

extension Task where Success == Never, Failure == Never {
    
    static func randomDelay() async {
        let delay: Int = (0...2).randomElement()!
        try! await Task.sleep(for: .seconds(delay))
    }
    
}
