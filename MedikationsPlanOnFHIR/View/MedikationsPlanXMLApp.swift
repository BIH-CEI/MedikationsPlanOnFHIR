//
//  MedikationsPlanXMLApp.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 31.08.21.
//

import SwiftUI

@main
struct MedikationsPlanXMLApp: App {
    let smart = SMARTClient.shared.smart
        
    var body: some Scene {
        WindowGroup {            
            ContentView()
                .onOpenURL(perform: { url in
                    print("MedikationsPlanXMLApp: Opening the url: \(url)")
                    // "smart" is your SMART `Client` instance
                    if smart.awaitingAuthCallback {
                        print("MedikationsPlanXMLApp: \(smart.didRedirect(to: url))")
                    }
                })
        }
    }
}
