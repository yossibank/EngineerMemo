import UIKit

extension UIImage {
    func resized(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { _ in
            draw(in: .init(origin: .zero, size: size))
        }
    }
}
