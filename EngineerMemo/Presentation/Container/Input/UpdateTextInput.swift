import UIKit

struct UpdateTextInput {
    let title: String
    let icon: UIImage
    let placeholder: String
    let keyboardType: UIKeyboardType

    init(
        title: String,
        icon: UIImage,
        placeholder: String,
        keyboardType: UIKeyboardType = .default
    ) {
        self.title = title
        self.icon = icon
        self.placeholder = placeholder
        self.keyboardType = keyboardType
    }
}
