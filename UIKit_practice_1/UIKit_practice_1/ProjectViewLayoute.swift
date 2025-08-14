
import UIKit

struct ProjectViewLayoute {
    let overlayFrame: CGRect
    let tableViewFrame: CGRect
    
    init(
        bounds: CGRect,
        safeAreaInsets: UIEdgeInsets,
        visibility: CGFloat
    ) {
        let overlayHeight = minOverlayHeight + variableOverlayHeight * visibility + safeAreaInsets.bottom
        tableViewFrame = CGRect(
            x: 0,
            y: safeAreaInsets.top,
            width: bounds.width,
            height: bounds.height - safeAreaInsets.top
        )
        overlayFrame = CGRect(
            x: 0,
            y: bounds.height - overlayHeight,
            width: bounds.width,
            height: overlayHeight
        )
    }
}

private let minOverlayHeight: CGFloat = 25
private let variableOverlayHeight: CGFloat = 75
