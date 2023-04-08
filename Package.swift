// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    
    name: "CombineTestbox",
    
    platforms:
        [
            .iOS(.v13),
            .macOS(.v10_15)
        ],
    
    products:
        [
            .library(
                name: "CombineTestbox",
                targets:
                    [
                        "CombineTestbox"
                    ]
            ),
        ],
    
    dependencies:
        [
            .package(url: "https://github.com/stuedev/StateMachine.git", branch: "main"),
            .package(url: "https://github.com/stuedev/GeneratedTestCase.git", branch: "main"),
            .package(url: "https://github.com/Quick/Quick.git", branch: "main"),
            .package(url: "https://github.com/Quick/Nimble.git", branch: "main")
        ],
    
    targets:
        [
            // Sources
            
            .target(
                name: "CombineTestbox",
                dependencies:
                    [
                        "StateMachine"
                    ]
            ),
            
            .target(
                name: "TestUtility",
                dependencies:
                    [
                        "CombineTestbox"
                    ]
            ),

            
            // Tests
            
            .testTarget(
                name: "FeatureTests",
                dependencies:
                    [
                        "CombineTestbox",
                        "TestUtility",
                        "GeneratedTestCase"
                    ]
            ),
            
            .testTarget(
                name: "UnitTests",
                dependencies:
                        [
                            "CombineTestbox",
                            "TestUtility",
                            "Quick",
                            "Nimble"
                        ]
            ),
            
            .testTarget(
                name: "TestUtilityTests",
                dependencies:
                    [
                        "CombineTestbox",
                        "TestUtility"
                    ]
            ),
            
            
            // Examples
            
            .testTarget(
                name: "Examples",
                dependencies:
                    [
                        "CombineTestbox"
                    ]
            )
        ]
)
