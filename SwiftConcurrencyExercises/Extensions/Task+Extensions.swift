//
//  Task+Extensions.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 25/09/2024.
//

extension Task where Success == Never, Failure == Never {
    
    static func randomDelay() async {
        let delay: Int = (0...2).randomElement()!
        try! await Task.sleep(for: .seconds(delay))
    }
    
}
