#if DEBUG
    import Foundation

    final class DebugModel {
        enum ArrayType {
            case add
            case delete
        }

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

        func updateDate(_ value: Date) {
            DataHolder.date = value
        }

        func updateArray(
            type: ArrayType,
            _ value: String
        ) {
            switch type {
            case .add:
                DataHolder.array.append(value)

            case .delete:
                DataHolder.array = DataHolder.array.filter {
                    $0 != value
                }
            }
        }

        func updateOptional(_ value: String?) {
            DataHolder.optional = value
        }

        func updateOptionalBool(_ value: Bool?) {
            DataHolder.optionalBool = value
        }
    }
#endif
