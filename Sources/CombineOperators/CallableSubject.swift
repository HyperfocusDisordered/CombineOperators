//
//  File 2.swift
//  
//
//  Created by  Denis Ovchar on 16.11.2023.
//

import Combine

class CallableSubject<T> {

    let subject = PassthroughSubject<T, Never>()

    func callAsFunction(_ arg: T) {
        subject.send(arg)
    }

}

extension CallableSubject where T == Void {
    func callAsFunction() {
        subject.send(())
    }
}

extension CallableSubject: Publisher {
    typealias Output = T
    typealias Failure = Never

    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, T == S.Input {
        subject.receive(subscriber: subscriber)
    }
}
