import UIKit

extension UIStackView {
    func add(arrangeSubview: UIView...) {
        for subview in arrangeSubview {
            addArrangedSubview(subview)
        }
    }
}
