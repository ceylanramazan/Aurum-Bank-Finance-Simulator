import ProjectDescription

public extension Project {

    /// Standard internal framework module shared by every Aurum Bank layer (Core, Network,
    /// Storage, Security, DesignSystem, Shared, and future Features/* modules).
    /// Keeping target generation in one place means every module gets identical
    /// deployment target / Swift version settings instead of N copy-pasted manifests.
    static func module(
        name: String,
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = nil
    ) -> Project {
        Project(
            name: name,
            targets: [
                .target(
                    name: name,
                    destinations: .iOS,
                    product: .framework,
                    bundleId: "com.ramazanceylan.aurumbank.\(name.lowercased())",
                    deploymentTargets: .iOS("26.4"),
                    sources: ["Sources/**"],
                    resources: resources,
                    dependencies: dependencies
                )
            ]
        )
    }
}
