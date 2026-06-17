import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "NetworkKit",
    dependencies: [.project(target: "Core", path: "../Core")]
)
