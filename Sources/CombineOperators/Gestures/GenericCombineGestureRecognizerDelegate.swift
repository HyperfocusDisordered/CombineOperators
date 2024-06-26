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


#if os(iOS) && canImport(UIKit)
import UIKit
#elseif os(OSX) && canImport(AppKit)
import AppKit
#endif
import Combine

public struct GestureRecognizerDelegatePolicy<PolicyInput> {
    public typealias PolicyBody = (PolicyInput) -> Bool

    private let policy: PolicyBody

    private init(policy: @escaping PolicyBody) {
        self.policy = policy
    }

    public static func custom(_ policy: @escaping PolicyBody)
        -> GestureRecognizerDelegatePolicy<PolicyInput> {
            .init(policy: policy)
    }

    public static var always: GestureRecognizerDelegatePolicy<PolicyInput> {
        .init { _ in true }
    }

    public static var never: GestureRecognizerDelegatePolicy<PolicyInput> {
        .init { _ in false }
    }

    public func isPolicyPassing(with args: PolicyInput) -> Bool {
        policy(args)
    }
}

public func || <PolicyInput>(lhs: GestureRecognizerDelegatePolicy<PolicyInput>, rhs: GestureRecognizerDelegatePolicy<PolicyInput>) -> GestureRecognizerDelegatePolicy<PolicyInput>  {
    return .custom { input in
        lhs.isPolicyPassing(with: input) || rhs.isPolicyPassing(with: input)
    }
}

public func && <PolicyInput>(lhs: GestureRecognizerDelegatePolicy<PolicyInput>, rhs: GestureRecognizerDelegatePolicy<PolicyInput>) -> GestureRecognizerDelegatePolicy<PolicyInput>  {
    return .custom { input in
        lhs.isPolicyPassing(with: input) && rhs.isPolicyPassing(with: input)
    }
}

public final class GenericRxGestureRecognizerDelegate<Gesture: CombineGestureRecognizer>: NSObject, CombineGestureRecognizerDelegate {

    /// Corresponding delegate method: gestureRecognizerShouldBegin(:_)
    public var beginPolicy: GestureRecognizerDelegatePolicy<Gesture> = .always

    /// Corresponding delegate method: gestureRecognizer(_:shouldReceive:)
    public var touchReceptionPolicy: GestureRecognizerDelegatePolicy<(Gesture, CombineGestureTouch)> = .always

    /// Corresponding delegate method: gestureRecognizer(_:shouldBeRequiredToFailBy:)
    public var selfFailureRequirementPolicy: GestureRecognizerDelegatePolicy<(Gesture, CombineGestureRecognizer)> = .never

    /// Corresponding delegate method: gestureRecognizer(_:shouldRequireFailureOf:)
    public var otherFailureRequirementPolicy: GestureRecognizerDelegatePolicy<(Gesture, CombineGestureRecognizer)> = .never

    /// Corresponding delegate method: gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)
    public var simultaneousRecognitionPolicy: GestureRecognizerDelegatePolicy<(Gesture, CombineGestureRecognizer)> = .always

    #if os(iOS) && canImport(UIKit)
    // Workaround because we can't have stored properties with @available annotation
    private var _pressReceptionPolicy: Any?

    /// Corresponding delegate method: gestureRecognizer(_:shouldReceive:)
    public var pressReceptionPolicy: GestureRecognizerDelegatePolicy<(Gesture, UIPress)> {
        get {
            _pressReceptionPolicy as? GestureRecognizerDelegatePolicy<(Gesture, UIPress)> ?? .always
        }
        set {
            _pressReceptionPolicy = newValue
        }
    }
    #endif

    #if os(OSX) && canImport(AppKit)
    /// Corresponding delegate method: gestureRecognizer(_:shouldAttemptToRecognizeWith:)
    public var eventRecognitionAttemptPolicy: GestureRecognizerDelegatePolicy<(Gesture, NSEvent)> = .always
    #endif

    public func gestureRecognizerShouldBegin(
        _ gestureRecognizer: CombineGestureRecognizer
        ) -> Bool {
        beginPolicy.isPolicyPassing(with: gestureRecognizer as! Gesture)
    }

    public func gestureRecognizer(
        _ gestureRecognizer: CombineGestureRecognizer,
        shouldReceive touch: CombineGestureTouch
        ) -> Bool {
        touchReceptionPolicy.isPolicyPassing(
            with: (gestureRecognizer as! Gesture, touch)
        )
    }

    public func gestureRecognizer(
        _ gestureRecognizer: CombineGestureRecognizer,
        shouldRequireFailureOf otherGestureRecognizer: CombineGestureRecognizer
        ) -> Bool {
        otherFailureRequirementPolicy.isPolicyPassing(
            with: (gestureRecognizer as! Gesture, otherGestureRecognizer)
        )
    }

    public func gestureRecognizer(
        _ gestureRecognizer: CombineGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: CombineGestureRecognizer
        ) -> Bool {
        selfFailureRequirementPolicy.isPolicyPassing(
            with: (gestureRecognizer as! Gesture, otherGestureRecognizer)
        )
    }

    public func gestureRecognizer(
        _ gestureRecognizer: CombineGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: CombineGestureRecognizer
        ) -> Bool {
        simultaneousRecognitionPolicy.isPolicyPassing(
            with: (gestureRecognizer as! Gesture, otherGestureRecognizer)
        )
    }

    #if os(iOS) && canImport(UIKit)

    public func gestureRecognizer(
        _ gestureRecognizer: CombineGestureRecognizer,
        shouldReceive press: UIPress
        ) -> Bool {
        pressReceptionPolicy.isPolicyPassing(
            with: (gestureRecognizer as! Gesture, press)
        )
    }

    #endif

    #if os(OSX) && canImport(AppKit)

    public func gestureRecognizer(
        _ gestureRecognizer: CombineGestureRecognizer,
        shouldAttemptToRecognizeWith event: NSEvent
        ) -> Bool {
        eventRecognitionAttemptPolicy.isPolicyPassing(
            with: (gestureRecognizer as! Gesture, event)
        )
    }

    #endif

}


#endif
