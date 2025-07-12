//
//  BubbleLevelAppApp.swift
//  BubbleLevelApp
//
//  Created by Michael Vilabrera on 7/11/25.
//

import SwiftUI

@main
struct BubbleLevelAppApp: App {
    var body: some Scene {
        WindowGroup {
            LevelView()
                .environment(MotionDetector(updateInterval: 0.01))
        }
    }
}
