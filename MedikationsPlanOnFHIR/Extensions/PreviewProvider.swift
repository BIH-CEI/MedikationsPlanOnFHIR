//
//  PreviewProvider2.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 12.03.22.
//

import Foundation
import SwiftUI

/// Extension declaring dev variable to access the Developer preview in the de
extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

/// DeveloperPreview Class that lows us to test the UKF in the SwiftUI Preview
class DeveloperPreview {
    /// Singleton variable
    static let instance = DeveloperPreview()
    /// ViewModel vairable to store the MP
    let mpvm = MPVM.shared
    /// Root element of the Medikationsplan
    let model: MedikationsPlanUKF
    /// Test JSON in UKF
    let inputMedikationsPlan = """
    <MP v="024" u="MPP" U="56DEC1A02F9340A1BA73704ABEF8B704" l="de-DE">
        <P t="Prof. Dr." g="Jürgen Test" z="Graf" v="von und zu" f="Wernersen" b="19400324" egk="A123456789" s="M"/>
        <A n="Krankenhaus" kik="1656304456" t="2017-05-02T12:00:00"/>
        <O w="89" c="1.3" p="1" h="177" b="1"/>
        <S c="411">
            <M p="4877970" m="2 bei Bedarf" t="max. 3" du="5" i="akut" r="Herzschmerzen"/>
            <M p="2083906" h="1" du="1" i="bei Bedarf" r="Schlaflosigkeit"/>
        </S>
    </MP>
    """
    /// Constructor 
    init() {
        model = UKFUtility.buildMedikationsPlanUKF(data: inputMedikationsPlan)!
        Task {
            await UKFUtility.createMedikationsPlanUKF(medikationsPlan: model)
        }
    }
}
