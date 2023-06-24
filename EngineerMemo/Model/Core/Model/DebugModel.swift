#if DEBUG
    import Foundation

    /// @mockable
    protocol DebugModelInput {
        func updateColorTheme(_ value: Int)
    }

    struct DebugModel: DebugModelInput {
        func updateColorTheme(_ value: Int) {
            DataHolder.colorTheme = .init(rawValue: value) ?? .system
        }
    }
#endif
