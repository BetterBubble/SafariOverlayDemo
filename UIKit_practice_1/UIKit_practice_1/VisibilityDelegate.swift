
import UIKit

class VisibilityDelegate {
    
    private let visibilityChanged: () -> Void
    
    private(set) var currentVisibility: CGFloat = 1 {
        didSet {
            currentVisibility = clamp(currentVisibility, min: 0, max: 1)
            visibilityChanged()
        }
    }
    
    private var initialOffset: CGFloat?
    private var isStartedAddBottom: Bool?
    
    init(visibilityChanged: @escaping () -> Void) {
        self.visibilityChanged = visibilityChanged
    }
    
    func setVisibility(_ visibility: CGFloat, animated: Bool) {
        guard animated else {
            currentVisibility = visibility
            return
        }
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            self?.currentVisibility = visibility
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        initialOffset = scrollView.contentOffset.y
        isStartedAddBottom = scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let initialOffset else { return }
        let offset = scrollView.contentOffset.y - initialOffset
        guard scrollView.contentOffset.y > 0 else {
            setVisibility(1, animated: true)
            return
        }
        guard isStartedAddBottom != true || offset < 0 else {
            if offset > thresshold {
                setVisibility(1, animated: true)
                return
            }
            return
        }
        
        if offset < 0 {
            let visibility = clamp(-offset / thresshold, min: currentVisibility, max: 1)
            if visibility > 0.5 {
                setVisibility(1, animated: true)
            } else {
                currentVisibility = visibility
            }
        } else {
            let visibility = clamp(1 - offset / thresshold, min: 0, max: currentVisibility)
            if visibility < 0.5 {
                setVisibility(0, animated: true)
            } else {
                currentVisibility = visibility
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            finishHandling()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        finishHandling()
    }
    
    private func finishHandling() {
        setVisibility(round(currentVisibility), animated: true)
        initialOffset = nil
    }
}

private let thresshold: CGFloat = 100
