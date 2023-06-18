#if DEBUG
    import Foundation

    /// @mockable
    protocol DebugModelInput {
        func updateColorTheme(_ value: Int)
    }

    final class DebugModel: DebugModelInput {
        func updateColorTheme(_ value: Int) {
            DataHolder.colorTheme = .init(rawValue: value) ?? .system
        }
    }
#endif
