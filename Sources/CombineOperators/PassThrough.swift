//
//  File.swift
//  
//
//  Created by  Denis Ovchar on 16.11.2023.
//

import Combine

//@dynamicMemberLookup
@propertyWrapper
public class PassThrough<Output> {
    public typealias Failure = Never
    public var wrappedValue: Output? {
        get { savedLast }
        set {
            savedLast = newValue
            if let newValue {
                projectedValue.send(newValue)
            }
        }
    }
    public let projectedValue: PassthroughSubject<Output, Never>
    private var savedLast: Output?

    public init() {
        projectedValue = PassthroughSubject()
    }
    //    public subscript <R>(dynamicMember keyPath: KeyPath<Output, R>) -> ObservableChain<R, Failure> {
    //        ObservableChain<R, Failure>(observable: projectedValue.map { $0[keyPath: keyPath] }.any())
    //    }
}
//@dynamicMemberLookup
//public struct ObservableChain<Output, Failure: Error> {
//    let observable: AnyPublisher<Output, Failure>
//    var cancelables: [AnyCancellable] = []
//
//    public subscript <R>(dynamicMember keyPath: KeyPath<Output, R>) -> ObservableChain<R, Failure> {
//        ObservableChain<R, Failure>(observable: self.map { $0[keyPath: keyPath] }.any() )
//    }
//}
//
//extension ObservableChain: Publisher {
//
//    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
//        observable.receive(subscriber: subscriber)
//    }
//
//    public typealias Output = Output
//
//    public typealias Failure = Failure
//
//}



extension PassThrough: Subscriber {
    public var combineIdentifier: CombineIdentifier {
        .init()
    }

    public func receive(completion: Subscribers.Completion<Failure>) {

    }

    public func receive(_ input: Output) -> Subscribers.Demand {
        wrappedValue = input
        return .unlimited
    }

    public func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    public typealias Input = Output
}

extension PassThrough: Publisher {
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Output == S.Input {
        projectedValue.receive(subscriber: subscriber)
    }


}
