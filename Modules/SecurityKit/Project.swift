import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "SecurityKit",
    dependencies: [.project(target: "Core", path: "../Core")]
)
