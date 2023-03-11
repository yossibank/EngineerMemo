#if DEBUG
    final class DebugModel {
        func updateSample(_ value: DataHolder.Sample) {
            DataHolder.sample = value
        }

        func updateTest(_ value: DataHolder.Test) {
            DataHolder.test = value
        }

        func updateString(_ value: String) {
            DataHolder.string = value
        }

        func updateInt(_ value: Int) {
            DataHolder.int = value
        }

        func updateBool(_ value: Bool) {
            DataHolder.bool = value
        }
    }
#endif
