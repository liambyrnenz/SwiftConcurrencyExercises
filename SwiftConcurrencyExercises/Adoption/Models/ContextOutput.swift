//
//  ContextOutput.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 17/11/2026.
//

import Synchronization

final class ContextOutput: Sendable {
    enum Stage: Equatable {
        case outletOpened(identifier: AdoptionOutlet.Identifier)
        case managerReceivedSubmitRequest(cat: Cat)
        case managerReceivedRemoveRequest(cat: Cat)
        case submitAdoptionRequestStart(cat: Cat, identifier: AdoptionOutlet.Identifier)
        case submitAdoptionRequestEnd(cat: Cat, identifier: AdoptionOutlet.Identifier)
        case removeAdoptionRequestStart(cat: Cat, identifier: AdoptionOutlet.Identifier)
        case removeAdoptionRequestEnd(cat: Cat, identifier: AdoptionOutlet.Identifier)
    }

    private let stages = Mutex<[Stage]>([])

    var stagesToRead: [Stage] {
        stages.withLock { $0 }
    }

    func add(stages: [Stage]) {
        self.stages.withLock {
            $0.append(contentsOf: stages)
        }
    }
}
