import UIKit

extension UIView {
    func add(subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}
