import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "Transfer",
    dependencies: [
        .project(target: "Core", path: "../../Core"),
        .project(target: "BankingUseCases", path: "../../BankingUseCases"),
    ]
)
