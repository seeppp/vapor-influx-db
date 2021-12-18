// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VaporInfluxDB",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "InfluxDB",
            targets: ["InfluxDB"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(
            name: "influxdb-client-swift",
            url: "https://github.com/influxdata/influxdb-client-swift",
            from: "0.9.0"
        ),
    ],
    targets: [
        .target(name: "InfluxDB", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "InfluxDBSwift", package: "influxdb-client-swift"),
            .product(name: "InfluxDBSwiftApis", package: "influxdb-client-swift"),
        ]),
        .testTarget(name: "InfluxDBTests", dependencies: [
            .target(name: "InfluxDB"),
        ]),
    ]
)
