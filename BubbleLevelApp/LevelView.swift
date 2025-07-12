//
//  LevelView.swift
//  BubbleLevelApp
//
//  Created by Michael Vilabrera on 7/11/25.
//

import SwiftUI

struct LevelView: View {
    @Environment(MotionDetector.self) var motionDetector
    
    var body: some View {
        VStack {
            BubbleLevel()
            OrientationDataView()
                .padding(.top, 80)
        }
        .onAppear {
            motionDetector.start()
        }
        .onDisappear {
            motionDetector.stop()
        }
    }
}

struct LevelView_Previews: PreviewProvider {
    @State static var motionDetector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        LevelView()
            .environment(motionDetector)
    }
}
