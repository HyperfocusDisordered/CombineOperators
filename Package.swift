// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "CombineOperators",
    platforms: [
        .iOS(.v13), .macOS(.v10_10), .watchOS(.v5), .tvOS(.v9),
    ],
    products: [
			.library(name: "CombineOperators", targets: ["CombineOperators"]),
    ],
    dependencies: [
			.package(url: "https://github.com/HyperfocusDisordered/FoundationExtensions.git", revision: "f9c0b8d7f5b7fa5ba6592d84d511b414be0cde6b"),
    ],
    targets: [
			.target(name: "CombineOperators", dependencies: ["FoundationExtensions"]),
    ]
)
