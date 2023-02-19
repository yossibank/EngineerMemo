enum ContentViews {
    enum Memo {
        static func List() -> MemoListContentView {
            .init()
        }
    }

    enum Profile {
        static func Detail() -> ProfileDetailContentView {
            .init()
        }

        static func Update(modelObject: ProfileModelObject? = nil) -> ProfileUpdateContentView {
            .init(modelObject: modelObject)
        }
    }

    #if DEBUG
        enum Debug {
            static func Development() -> DebugDevelopmentContentView {
                .init()
            }

            enum CoreData {
                static func Create() -> DebugCoreDataCreateContentView {
                    .init()
                }

                static func List() -> DebugCoreDataListContentView {
                    .init()
                }

                static func Update() -> DebugCoreDataUpdateContentView {
                    .init()
                }
            }

            enum CoreDataObject {
                enum Create {
                    static func Profile() -> DebugProfileCreateContentView {
                        .init()
                    }
                }

                enum List {
                    static func Profile() -> DebugProfileListContentView {
                        .init()
                    }
                }

                enum Update {
                    static func Profile() -> DebugProfileUpdateContentView {
                        .init()
                    }
                }
            }
        }
    #endif
}
