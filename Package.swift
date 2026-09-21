// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Caseboard",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Caseboard",
            targets: ["Caseboard"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Caseboard",
            dependencies: [],
            path: "Sources/Caseboard",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "CaseboardTests",
            dependencies: ["Caseboard"],
            path: "Tests/CaseboardTests"
        )
    ]
)
