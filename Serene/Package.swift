// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Serene",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Serene",
            targets: ["Serene"]
        ),
    ],
    targets: [
        .target(
            name: "Serene",
            path: "."
        ),
    ]
)
