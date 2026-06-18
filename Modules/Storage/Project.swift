import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "Storage",
    dependencies: [
        .project(target: "Core", path: "../Core"),
        .project(target: "BankingDomain", path: "../BankingDomain"),
    ]
)
