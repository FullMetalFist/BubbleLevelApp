//
//  MotionDetector.swift
//  BubbleLevelApp
//
//  Created by Michael Vilabrera on 7/11/25.
//

import CoreMotion
import UIKit

@Observable
class MotionDetector {
    private let motionManager = CMMotionManager()
    
    private var timer = Timer()
    private var updateInterval: TimeInterval
    
    var pitch: Double = 0
    var roll: Double = 0
    var zAcceleration: Double = 0
    
    var onUpdateClosure: (() -> Void) = {}
    
    private var currentOrientation: UIDeviceOrientation = .landscapeLeft
    private var orientationObserver: NSObjectProtocol? = nil
    
    let notification = UIDevice.orientationDidChangeNotification
    
    init(updateInterval: TimeInterval) {
        self.updateInterval = updateInterval
    }
    
    func start() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        orientationObserver = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main) { [weak self] _ in
            switch UIDevice.current.orientation {
            case .faceUp, .faceDown, .unknown:
                break
            default:
                self?.currentOrientation = UIDevice.current.orientation
            }
        }
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates()
            
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                self.updateMotionData()
            }
        } else {
            print("Motion data isn't available on this device.")
        }
    }
    
    func updateMotionData() {
        if let data = motionManager.deviceMotion {
            (roll, pitch) = currentOrientation.adjustedRollAndPitch(data.attitude)
            zAcceleration = data.userAcceleration.z
            
            onUpdateClosure()
        }
    }
    
    func stop() {
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
        if let orientationObserver = orientationObserver {
            NotificationCenter.default.removeObserver(orientationObserver, name: notification, object: nil)
        }
        orientationObserver = nil
    }
    
    deinit {
        stop()
    }
}

extension MotionDetector {
    func started() -> MotionDetector {
        start()
        return self
    }
}

extension UIDeviceOrientation {
    func adjustedRollAndPitch(_ attitude: CMAttitude) -> (roll: Double, pitch: Double) {
        switch self {
        case .unknown, .faceUp, .faceDown:
            return (attitude.roll, -attitude.pitch)
        case .landscapeLeft:
            return (attitude.pitch, -attitude.roll)
        case .portrait:
            return (attitude.roll, attitude.pitch)
        case .portraitUpsideDown:
            return (-attitude.roll, -attitude.pitch)
        case .landscapeRight:
            return (-attitude.pitch, attitude.roll)
        @unknown default:
            return (attitude.roll, attitude.pitch)
        }
    }
}
