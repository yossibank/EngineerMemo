#if DEBUG
    final class DebugModel {
        func updateSample(_ sample: DataHolder.Sample) {
            DataHolder.sample = sample
        }

        func updateTest(_ test: DataHolder.Test) {
            DataHolder.test = test
        }
    }
#endif
