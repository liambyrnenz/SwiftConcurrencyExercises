//
//  ContentViewModel.swift
//  SwiftConcurrencyExercises
//
//  Created by Liam on 18/09/2024.
//

protocol ContentViewModel {
    func start()
}

class ContentViewModelImpl: ContentViewModel {
    
    func start() {
        
    }
    
}

struct ContentViewModelMock: ContentViewModel {
    func start() {}
}
