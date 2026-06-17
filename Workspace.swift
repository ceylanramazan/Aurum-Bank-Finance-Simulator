import ProjectDescription

let workspace = Workspace(
    name: "AurumBank",
    projects: [
        "App",
        "Modules/BankingDomain",
        "Modules/Core",
        "Modules/NetworkKit",
        "Modules/Storage",
        "Modules/SecurityKit",
        "Modules/DesignSystem",
        "Modules/Shared",
        // Add each new feature module's path here as it's created, e.g. "Modules/Features/Onboarding".
    ]
)
