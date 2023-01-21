import UIKit

extension UITextField {
    func setUnderLine() {
        borderStyle = .none

        let underline = UIView()
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
        underline.backgroundColor = .red

        addSubview(underline)
        bringSubviewToFront(underline)
    }
}
