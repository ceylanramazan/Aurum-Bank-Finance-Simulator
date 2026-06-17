import ProjectDescription

let appName = "Aurum Bank – Finance Simulator"
let bundleID = "com.ramazanceylan.Aurum-Bank---Finance-Simulator"

let project = Project(
    name: appName,
    targets: [
        .target(
            name: appName,
            destinations: .iOS,
            product: .app,
            bundleId: bundleID,
            deploymentTargets: .iOS("26.4"),
            infoPlist: .file(path: "\(appName)/Info.plist"),
            sources: ["\(appName)/**/*.swift"],
            resources: [
                "\(appName)/Assets.xcassets",
                "\(appName)/Base.lproj/**",
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
