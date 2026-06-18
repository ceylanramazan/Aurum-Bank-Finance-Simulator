import ProjectDescription

let project = Project(
    name: "AurumBank",
    targets: [
        .target(
            name: "AurumBank",
            destinations: .iOS,
            product: .app,
            bundleId: "com.ramazanceylan.Aurum-Bank---Finance-Simulator",
            deploymentTargets: .iOS("26.4"),
            infoPlist: .file(path: "Resources/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/Assets.xcassets"],
            dependencies: [
                .project(target: "Core", path: "../Modules/Core"),
                .project(target: "BankingDomain", path: "../Modules/BankingDomain"),
                .project(target: "BankingUseCases", path: "../Modules/BankingUseCases"),
                .project(target: "NetworkKit", path: "../Modules/NetworkKit"),
                .project(target: "Storage", path: "../Modules/Storage"),
                .project(target: "SecurityKit", path: "../Modules/SecurityKit"),
                .project(target: "DesignSystem", path: "../Modules/DesignSystem"),
                .project(target: "Shared", path: "../Modules/Shared"),
            ],
            settings: .settings(
                base: [
                    "MARKETING_VERSION": "1.0",
                    "CURRENT_PROJECT_VERSION": "1",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "SWIFT_VERSION": "5.0",
                ]
            )
        ),
    ]
)
