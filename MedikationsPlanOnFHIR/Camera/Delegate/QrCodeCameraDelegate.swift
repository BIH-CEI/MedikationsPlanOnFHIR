//
//  QrCodeCameraDelegate.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 21.10.21.
//

import Foundation
import AVFoundation

/// Responsible for handling the output, checking the object and informing the parent
class QrCodeCameraDelegate: NSObject,
                            AVCaptureMetadataOutputObjectsDelegate {
    
    var scanInterval: Double = 1.0
    var lastTime = Date(timeIntervalSince1970: 0)
    
    var onResult: (String) -> Void = { _  in }
    var mockData: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            foundBarcode(stringValue)
        }
    }
    
    @objc func onSimulateScanning() {
        foundBarcode(mockData ?? "Simulated QR-code result.")
    }
    
    func foundBarcode(_ stringValue: String) {
        print("Delegate: foundBarcode - stringValue")
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval {
            print("Inside")
            lastTime = now
            self.onResult(stringValue)
        }
    }
}
