# SwiftConcurrencyExercises

This repository explores Swift Concurrency and its features through hands-on exercises, for the purposes of learning, visualising behaviour and developing best practices.

## Context

The exercise context centres around feline adoption. Adoption outlets (i.e. branches of an adoption agency) utilise two components to manage adoptions: a service to fetch details of their cats when they open, and a central manager that tracks the number of adoption requests for cats across all outlets. 

Usage of a service here firstly demonstrates utilising async/await and task groups to handle concurrent access to another object which does not modify state. Following that, the outlets then begin their own sequences of adoption request submission and removal in their own tasks, calling on the manager component concurrently to update its underlying storage. The manager is implemented as an actor, so it should sequence these calls. If it were not implemented as an actor, concurrent access would lead to runtime issues and other measures would be needed to handle concurrent modifications. 

## TODO
- Add non-Swift Concurrency implementation using prior standard technology (e.g. threads) to show difference in behaviour and usage vs actors
