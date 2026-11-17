//
//  ContextOutput.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 17/11/2026.
//

actor ContextOutput {
    enum Stage: Equatable {
        case outletOpened(identifier: AdoptionOutlet.Identifier)
        case managerReceivedSubmitRequest(cat: Cat)
        case managerReceivedRemoveRequest(cat: Cat)
        case submitAdoptionRequestStart(cat: Cat, identifier: AdoptionOutlet.Identifier)
        case submitAdoptionRequestEnd(cat: Cat, identifier: AdoptionOutlet.Identifier)
        case removeAdoptionRequestStart(cat: Cat, identifier: AdoptionOutlet.Identifier)
        case removeAdoptionRequestEnd(cat: Cat, identifier: AdoptionOutlet.Identifier)
    }

    private(set) var stages: [Stage] = []

    func add(stages: [Stage]) {
        self.stages.append(contentsOf: stages)
    }
}
