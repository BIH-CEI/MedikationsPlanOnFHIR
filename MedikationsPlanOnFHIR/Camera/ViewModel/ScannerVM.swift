//
//  ScannerVM.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 20.10.21.
//

import Foundation
import UIKit
import AVFoundation

/// The ViewModel for the scanner
class ScannerVM: ObservableObject {
    
    /// Defines how often we are gaoing to try looking for a new QR-code in the camera feed.
    let scanInterval: Double = 1.0
    /// Current state of the light
    @Published var torchIsOn: Bool = false
    /// Last scanned QR-Code
    @Published var lastQrCode: String = "Qr-code goes here"
    /// State if the camera is showing up 
    @Published var scanning: Bool = false
    /// Variable to store the GUID
    var guid: String = ""
    /// Variable to store the max page number
    var maxPage: String = ""
    /// Variable to store the MedikationsPlanUKF objects
    var medikationsPlanArr = [MedikationsPlanUKF?]()
    /// Pages to scan
    var pagesToScan: [Int]?
    
    /// Function to be called when a QR-Code is found | Identifies the amoung of pages
    func onFoundQrCode(_ code: String) {
        print("ScannerVM: onFoundQrCode (code)")
        // Check if the code is valid
        guard let medikationsPlan = UKFUtility.buildMedikationsPlanUKF(data: code) else {
            return
        }
        
        // Check if there are no scanned codes
        if medikationsPlanArr.isEmpty {
            // First time scanning
            guard let guardMaxPage = medikationsPlan.z, let guardActualPage = medikationsPlan.a else {
                // This will get executed if the values above are nil => No more pages, just one.
                playVibTone()
                // Add variable of scanned code to the array
                medikationsPlanArr.append(medikationsPlan)
                // conpactMap because the value could be optional
                UKFUtility.arrToObject(medikationsPlanArr: medikationsPlanArr.compactMap { $0 })
                // Close the scanner
                self.scanning = false
                return
            }
            // More pages MP
            playVibTone()
            medikationsPlanArr = [MedikationsPlanUKF?](repeating: nil, count: Int(guardMaxPage)!)
            guid = medikationsPlan.U
            maxPage = guardMaxPage
            pagesToScan = (1..<Int(maxPage)!+1).indices.map { $0 }
            pagesToScan!.remove(at: Int(guardActualPage)!-1)
            medikationsPlanArr[Int(guardActualPage)!-1] = medikationsPlan
            self.lastQrCode = "Die \(pagesToScan![0]). Seite scannen"
            
        } else { // Other results
            print("ScannerVM: onFoundQrCode More pages")
            // If medikationsPlan got a page and there still a page to scan continue else return
            guard let guardActualPage = medikationsPlan.a, !guardActualPage.isEmpty else {
                return
            }
            
            if pagesToScan![0] == Int(medikationsPlan.a!) && medikationsPlan.U == guid {
                playVibTone()
                medikationsPlanArr[Int(medikationsPlan.a!)!-1] = medikationsPlan
                if let index = pagesToScan!.firstIndex(of: Int(medikationsPlan.a!)!) {
                    pagesToScan!.remove(at: index)
                }
                if pagesToScan!.isEmpty {
                    self.scanning.toggle()
                    UKFUtility.arrToObject(medikationsPlanArr: medikationsPlanArr.compactMap { $0 })
                } else {
                    self.lastQrCode = "Die \(pagesToScan![0]). Seite scannen"
                }
            }
        }
    }
    
    func playVibTone() {
//        UINotificationFeedbackGenerator().notificationOccurred(.success)
//        AudioServicesPlaySystemSound(SystemSoundID(1007))
    }
        
    func startScanning() {
        print("ScannerVM: startScanning()")
        self.torchIsOn = false
        self.guid = ""
        self.maxPage = ""
        self.medikationsPlanArr = []
        self.scanning.toggle()
        self.lastQrCode = "Medikationsplan scannen"
    }
}
