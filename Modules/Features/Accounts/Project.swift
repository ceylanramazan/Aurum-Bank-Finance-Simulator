import ProjectDescription
import ProjectDescriptionHelpers

// Depends on BankingDomain directly (not BankingUseCases) — this screen only reads data
// through BankingService, there's no business operation here that needs a use case layer.
let project = Project.module(
    name: "Accounts",
    dependencies: [
        .project(target: "Core", path: "../../Core"),
        .project(target: "BankingDomain", path: "../../BankingDomain"),
    ]
)
