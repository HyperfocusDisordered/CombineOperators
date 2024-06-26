// Copyright (c) CombineSwiftCommunity

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
#if os(OSX) || os(iOS)

#if canImport(UIKit)

import UIKit
import Combine

public enum SwipeDirection {
    case right, left, up, down

    fileprivate typealias SwipeGestureRecognizerDirection = UISwipeGestureRecognizer.Direction
    
    fileprivate var direction: SwipeGestureRecognizerDirection {
        switch self {
        case .right: return .right
        case .left: return .left
        case .up: return .up
        case .down: return .down
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
private func make(direction: SwipeDirection, configuration: Configuration<UISwipeGestureRecognizer>?) -> Factory<UISwipeGestureRecognizer> {
    make {
        $0.direction = direction.direction
        configuration?($0, $1)
    }
}

@available(iOS 13.0, macOS 10.15, *)
public typealias SwipeConfiguration = Configuration<UISwipeGestureRecognizer>
@available(iOS 13.0, macOS 10.15, *)
public typealias SwipeControlEvent = ControlEvent<UISwipeGestureRecognizer>
@available(iOS 13.0, macOS 10.15, *)
public typealias SwipePublisher = AnyPublisher<UISwipeGestureRecognizer, Never>

@available(iOS 13.0, macOS 10.15, *)
extension Factory where Gesture == CombineGestureRecognizer {

    /**
     Returns an `AnyFactory` for `UISwipeGestureRecognizer`
     - parameter configuration: A closure that allows to fully configure the gesture recognizer
     */
    public static func swipe(direction: SwipeDirection, configuration: SwipeConfiguration? = nil) -> AnyFactory {
        make(direction: direction, configuration: configuration).abstracted()
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension Reactive where Base: CombineGestureView {

    /**
     Returns an observable `UISwipeGestureRecognizer` events sequence
     - parameter configuration: A closure that allows to fully configure the gesture recognizer
     */
    private func swipeGesture(direction: SwipeDirection,configuration: SwipeConfiguration? = nil) -> SwipeControlEvent {
        gesture(make(direction: direction, configuration: configuration))
    }

    /**
     Returns an observable `UISwipeGestureRecognizer` events sequence
     - parameter configuration: A closure that allows to fully configure the gesture recognizer
     */
    public func swipeGesture(_ directions: Set<SwipeDirection>,configuration: SwipeConfiguration? = nil) -> SwipeControlEvent {
			let source = Publishers.MergeMany(directions.map {
            swipeGesture(direction: $0, configuration: configuration)
        })
        return ControlEvent(events: source)
    }

    /**
     Returns an observable `UISwipeGestureRecognizer` events sequence
     - parameter configuration: A closure that allows to fully configure the gesture recognizer
     */
    public func swipeGesture(_ directions: SwipeDirection...,configuration: SwipeConfiguration? = nil) -> SwipeControlEvent {
        swipeGesture(Set(directions), configuration: configuration)
    }

}

#endif
#endif
