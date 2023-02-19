import UIKit
import UIKitHelper

extension UIDatePicker {
    static func makeTransparent(view: UIView) {
        if view.backgroundColor != nil {
            view.isHidden = true
        } else {
            for subview in view.subviews {
                makeTransparent(view: subview)
            }
        }
    }

    func expandPickerRange() {
        subviews.forEach {
            $0.subviews.forEach {
                $0.addConstraint {
                    $0.width.equalTo(snp.width).inset(28)
                }
            }
        }
    }
}
