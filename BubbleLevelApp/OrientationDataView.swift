//
//  OrientationDataView.swift
//  BubbleLevelApp
//
//  Created by Michael Vilabrera on 7/11/25.
//

import SwiftUI

struct OrientationDataView: View {
    @Environment(MotionDetector.self) var detector
    
    var rollString: String {
        detector.roll.describeAsFixedLengthString()
    }
    
    var pitchString: String {
        detector.pitch.describeAsFixedLengthString()
    }
    
    var body: some View {
        VStack {
            Text("Horizontal: " + rollString)
                .font(.system(.body, design: .monospaced))
            Text("Vertical: " + pitchString)
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct OrientationDataView_Previews: PreviewProvider {
    @State static private var motionDetector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        OrientationDataView()
            .environment(motionDetector)
    }
}
