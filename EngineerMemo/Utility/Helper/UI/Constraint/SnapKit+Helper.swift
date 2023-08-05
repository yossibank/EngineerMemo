import SnapKit
import UIKit

protocol ViewLayoutable {}

extension ViewLayoutable where Self: UIView {
    @discardableResult
    func addSubview(
        _ child: some UIView,
        _ configuration: (ConstraintMaker) -> Void
    ) -> Self {
        addSubview(child)
        child.snp.makeConstraints(configuration)
        return self
    }

    @discardableResult
    func addConstraint(_ configuration: (ConstraintMaker) -> Void) -> Self {
        snp.makeConstraints(configuration)
        return self
    }
}

extension UIView: ViewLayoutable {}
