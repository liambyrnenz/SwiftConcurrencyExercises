//
//  AdoptionService.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 25/09/2024.
//

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
