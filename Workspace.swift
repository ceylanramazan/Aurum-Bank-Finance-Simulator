import ProjectDescription

let workspace = Workspace(
    name: "AurumBank",
    projects: [
        "App",
        "Modules/BankingDomain",
        "Modules/BankingUseCases",
        "Modules/Core",
        "Modules/NetworkKit",
        "Modules/Storage",
        "Modules/SecurityKit",
        "Modules/DesignSystem",
        "Modules/Shared",
        "Modules/Features/Transfer",
        // Add each new feature module's path here as it's created, e.g. "Modules/Features/Onboarding".
    ]
)
