// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Formula",
    products: [
        .library(
            name: "Formula",
            targets: ["Formula"]),
    ],
    dependencies: [
            .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
        ],
    targets: [
        .target(
            name: "Formula"),
        .testTarget(
            name: "FormulaTests",
            dependencies: ["Formula"]),
    ]
)
