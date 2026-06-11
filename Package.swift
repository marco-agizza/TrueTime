// swift-tools-version: 5.9
// Package.swift
//
// Swift Package Manager manifest for TrueTime v5.1.0
// TrueTime is an NTP (Network Time Protocol) library for Swift.
//
// Architecture:
// - CTrueTime: C/Objective-C target containing NTP type definitions and bridging headers.
// - TrueTime: Pure Swift target containing the main library logic, depends on CTrueTime.
// - TrueTimeTests: Unit and integration tests for the TrueTime library.
//
// The library is split into two targets to satisfy SPM's restriction against
// mixing Swift and C/Objective-C sources within a single target.

import PackageDescription

let package = Package(
    name: "TrueTime",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "TrueTime",
            targets: ["TrueTime"]
        )
    ],
    dependencies: [],
    targets: [
        // MARK: - CTrueTime
        // C/Objective-C target providing NTP type definitions (ntp_types.h)
        // and any Objective-C bridging code (TrueTime.h, TrueTime.m).
        .target(
            name: "CTrueTime",
            dependencies: [],
            path: "Sources/CTrueTime",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Sources/CTrueTime")
            ]
        ),
        // MARK: - TrueTime
        // Pure Swift target containing the main NTP client implementation.
        // Depends on CTrueTime for C-level NTP type definitions.
        .target(
            name: "TrueTime",
            dependencies: ["CTrueTime"],
            path: "Sources/TrueTime",
            swiftSettings: [
                .define("SPM")
            ]
        ),
        .target(
            name: "Bridging",
            dependencies: ["CTrueTime", "TrueTime"],
            path: "Sources/Bridging"
        ),
        // MARK: - TrueTimeTests
        // Test target for unit and integration tests.
        .testTarget(
            name: "TrueTimeTests",
            dependencies: ["CTrueTime", "TrueTime", "Bridging"],
            path: "Tests/TrueTimeTests",
            sources: [
                "ArbitraryExtensions.swift",
                "NTPExtensionsSpec.swift",
                "NTPIntegrationSpec.swift"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
