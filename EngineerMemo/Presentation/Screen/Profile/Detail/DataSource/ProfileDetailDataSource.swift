enum ProfileDetailSection: CaseIterable {
    case top
    case main
}

enum ProfileDetailItem: Hashable {
    case top(ProfileModelObject?)
    case main(ProfileModelObject?)
}
