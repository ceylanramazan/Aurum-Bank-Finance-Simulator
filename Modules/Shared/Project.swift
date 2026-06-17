import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "Shared",
    dependencies: [.project(target: "Core", path: "../Core")]
)
