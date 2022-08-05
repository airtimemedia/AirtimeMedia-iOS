// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AirtimeMedia",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AirtimeMedia",
            targets: ["AirtimeMedia", "Bakersfield"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "AirtimeMedia",
            url: "https://airtime-eng-asilomar-libs.s3-accelerate.amazonaws.com/jobs/airtimemedia/asilomar/release%252F1.4/6/AirtimeMedia.xcframework.zip",
            checksum: "5a9f5873192881e329597b3a17cb80c0d48e45fe3f185c03c866aba017046863"
        ),
        .binaryTarget(
            name: "Bakersfield",
            url: "https://airtime-eng-asilomar-libs.s3-accelerate.amazonaws.com/jobs/airtimemedia/asilomar/release%252F1.4/6/Bakersfield.xcframework.zip",
            checksum: "49b4e005064bc797c2901582efa3a66d4bf0db0fd6f9bfe5b82c415403eabd37"
        ),
    ]
)
