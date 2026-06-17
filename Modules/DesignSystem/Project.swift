import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "DesignSystem",
    dependencies: [.project(target: "Core", path: "../Core")]
)
