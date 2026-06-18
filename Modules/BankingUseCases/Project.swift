import ProjectDescription

// Hand-written (not using Project.module) because this is the first module that ships its
// own unit test target — the framework target and the test target need to be declared
// together so the test target can depend on the framework one.
let project = Project(
    name: "BankingUseCases",
    targets: [
        .target(
            name: "BankingUseCases",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ramazanceylan.aurumbank.bankingusecases",
            deploymentTargets: .iOS("26.4"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "BankingDomain", path: "../BankingDomain"),
            ]
        ),
        .target(
            name: "BankingUseCasesTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ramazanceylan.aurumbank.bankingusecasestests",
            deploymentTargets: .iOS("26.4"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "BankingUseCases"),
            ]
        ),
    ]
)
