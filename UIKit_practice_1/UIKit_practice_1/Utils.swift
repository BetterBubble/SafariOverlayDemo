
import UIKit

extension CGFloat {
    func rounded(toStep step: CGFloat = 1) -> CGFloat {
        Foundation.round(self / step) * step
    }
    
    public var roundedToSreenScale: CGFloat {
        rounded(toStep: 1 / UIScreen.main.scale)
    }
}

func clamp<T: Comparable>(
    _ value: T, min minValue: T, max maxValue: T
) -> T {
    guard minValue <= maxValue else {
        assertionFailure()
        return minValue
    }
    return value.clamp(minValue...maxValue)
}

extension Comparable where Self: Strideable, Self.Stride: SignedInteger {
    func clamp(_ range: Range<Self>) -> Self? {
        guard !range.isEmpty else {
            return nil
        }
        return clamp(ClosedRange(range))
    }
}

extension Comparable {
    func clamp(_ range: ClosedRange<Self>) -> Self {
        max(range.lowerBound, min(range.upperBound, self))
    }
}







































