//
//  AdoptionManager.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 25/09/2024.
//

actor AdoptionManager {

    private(set) var adoptionRequestCounts: [Cat: Int] = [:]
    var induceRandomDelay: Bool = false

    func setInduceRandomDelay() {
        // This method is needed to allow callers outside the actor context to
        // set this property.
        induceRandomDelay = true
    }

    func submitAdoptionRequest(for cat: Cat) async {
        print("AdoptionManager received submit adoption request for \(cat)")
        if induceRandomDelay {
            await Task.randomDelay()
        }
        adoptionRequestCounts[cat, default: 0] += 1
    }

    func removeAdoptionRequest(for cat: Cat) async {
        print("AdoptionManager received remove adoption request for \(cat)")
        if induceRandomDelay {
            await Task.randomDelay()
        }
        adoptionRequestCounts[cat]? -= 1
        if adoptionRequestCounts[cat] == 0 {
            adoptionRequestCounts[cat] = nil
        }
    }

}
