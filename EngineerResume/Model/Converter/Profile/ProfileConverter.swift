/// @mockable
protocol ProfileConverterInput {
    func convert(_ objects: [Profile]) -> [ProfileModelObject]
}

struct ProfileConverter: ProfileConverterInput {
    func convert(_ objects: [Profile]) -> [ProfileModelObject] {
        objects.map {
            .init(
                name: $0.name ?? "",
                age: $0.age?.intValue
            )
        }
    }
}
