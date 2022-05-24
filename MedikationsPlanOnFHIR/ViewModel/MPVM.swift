//
//  MPVM.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 17.11.21.
//

import Foundation

class MPVM: ObservableObject {
    static let shared = MPVM()
    @MainActor @Published var medikationsPlanArr = [MedikationsPlanUKF]()
    
    @Published var fetching: Bool = false
    
    @Published var errorBool = false
    @Published var errorMessage = ""
}
