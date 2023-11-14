//
//  Combine++.swift
//  StoriesLMS
//
//  Created by  Denis Ovchar new on 16.04.2021.
//

import Combine
import CombineOperators
import Foundation


public struct ValueBinding<T> {

	public let publisher: AnyPublisher<T, Never>
	public let set: (T) -> ()

    public init(publisher: AnyPublisher<T, Never>, set: @escaping (T) -> ()) {
        self.publisher = publisher
        self.set = set
    }

	public init(_ currentValueSubject: CurrentValueSubject<T, Never>) {
        self.publisher = currentValueSubject.eraseToAnyPublisher()
        self.set = { currentValueSubject.value = $0 }
    }

	public init(just: T) {
        self.publisher = Just(just).any()
        self.set = { _ in }
    }

}

extension ValueBinding: Publisher {
	public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        publisher.receive(subscriber: subscriber)
    }
    
	public typealias Failure = Never
    
	public typealias Output = T
    
    
}

extension ValueBinding: Subscriber {
	public  typealias Input = T
    
	public var combineIdentifier: CombineIdentifier {
        CombineIdentifier()
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {

    }
    
    public func receive(_ input: Output) -> Subscribers.Demand {
        set(input)
        return .unlimited
    }
    
    public func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
}

public extension CurrentValueSubject where Failure == Never {
	func bind() -> ValueBinding<Output> {
		.init(self)
	}
}

public protocol WithCurrentValue {
    associatedtype Output
    var value: Output { get }
}

extension CurrentValueSubject: WithCurrentValue {
    
}

extension ValueSubject: WithCurrentValue {
	public var value: Output { wrappedValue }
}

public extension Publisher {
    func withPrevious() -> AnyPublisher<(previous: Output?, current: Output), Failure> {
        scan(Optional<(Output?, Output)>.none) { ($0?.1, $1) }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func withPrevious(_ initialPreviousValue: Output) -> AnyPublisher<(previous: Output, current: Output), Failure> {
            scan((initialPreviousValue, initialPreviousValue)) { ($0.1, $1) }.eraseToAnyPublisher()
        }
}


public extension Publisher {
    func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        sink(receiveCompletion: {_ in }, receiveValue: receiveValue)
    }
}

public extension Single {
	public init(queue: DispatchQueue = DispatchQueue.global(),
			 block: @escaping () throws -> Output,
			 catch: @escaping (Failure) -> () ) where Failure == Error
	{
		self.init { resultBlock in
			queue.async {
				do {
					let result = try block()
					resultBlock(.success(result))
				} catch {
					resultBlock(.failure(error))
				}
			}
		}
		
	}
}

public extension Scheduler where Self == DispatchQueue {
	static var main: DispatchQueue {
		DispatchQueue.main
	}
}



