@resultBuilder
enum ArrayBuilder<Element> {
    // 引数の子要素を収集して配列に結合
    static func buildBlock(_ components: Element...) -> [Element] {
        components
    }

    // Builder内でのif文使用
    static func buildOptional(_ component: [Element]?) -> [Element] {
        component ?? []
    }

    // Builder内でのswitch文、if-else文使用
    static func buildEither(first component: [Element]) -> [Element] {
        component
    }

    // Builder内でのswitch文、if-else文使用
    static func buildEither(second component: [Element]) -> [Element] {
        component
    }

    // Builder内でのfor-in文使用
    static func buildArray(_ components: [[Element]]) -> [Element] {
        components.flatMap { $0 }
    }

    // if #avaialble文の使用
    static func buildLimitedAvailability(_ component: [Element]) -> [Element] {
        component
    }

    // Builder内に新たな要素を生成する
    static func buildExpression(_ expression: Element) -> [Element] {
        [expression]
    }

    // Builder内の要素にnext要素を新たに結合する
    static func buildPartialBlock(first component: Element) -> [Element] {
        [component]
    }

    // Builder内の要素にnext要素を新たに結合する
    static func buildPartialBlock(first component: [Element]) -> [Element] {
        component
    }

    // Builder内の要素にnext要素を新たに結合する
    static func buildPartialBlock(accumulated: [Element], next: Element) -> [Element] {
        accumulated + [next]
    }

    // Builder内の要素にnext要素を新たに結合する
    static func buildPartialBlock(accumulated: [Element], next: [Element]) -> [Element] {
        accumulated + next
    }
}
