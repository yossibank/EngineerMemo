import Combine
import UIKit

// MARK: - properties & init

final class MenuButton: UIButton {
    @Published private(set) var isShowMenu = false
}

// MARK: - override methods

extension MenuButton {
    override func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        willDisplayMenuFor configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        super.contextMenuInteraction(
            interaction,
            willDisplayMenuFor: configuration,
            animator: animator
        )

        isShowMenu = true
    }

    override func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        willEndFor configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        super.contextMenuInteraction(
            interaction,
            willEndFor: configuration,
            animator: animator
        )

        isShowMenu = false
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MenuButtonPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: MenuButton())
        }
    }
#endif
