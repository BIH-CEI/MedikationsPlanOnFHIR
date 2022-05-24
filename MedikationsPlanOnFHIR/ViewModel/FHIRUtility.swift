//
//  FHIRUtility.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 30.11.21.
//

import Foundation
import FHIR

/// Returns the Dosage strcuture
func getDosage(quantityValue: String, time: String, dosierEinheitCode: String?, dosierEinheitText: String?, patInstruction: String?) -> Dosage {
    // Dosage resource
    let dosage = Dosage()
    // Timing for dosage
    let timing = Timing()
    // CodeableConcept for timing
    let timingCodeableConcept = CodeableConcept()
    // Array holding all the codings for timing
    var timingCodings = [Coding]()
    // Coding for timing
    var timingCoding = Coding()
    // Decorate coding for timing
    // TimingEvent
    timingCoding.system = FHIRURL("http://terminology.hl7.org/CodeSystem/v3-TimingEvent")
    timingCoding.code = time == "m" ? "CM" :
                        time == "d" ? "CD" :
                        time == "v" ? "CV" :
                        "HS"
    
    timingCoding.display = time == "m" ? "Morgens" :
                           time == "d" ? "Mittags" :
                           time == "v" ? "Abends" :
                           "zur Nacht"
    // Append the coding for timing to the array
    timingCodings.append(timingCoding)
    // SNOMED
    timingCoding = Coding()
    timingCoding.system = FHIRURL("http://snomed.info/sct")
    timingCoding.code = time == "m" ? "73775008" :
                        time == "d" ? "71997007" :
                        time == "v" ? "3157002" :
                        "2546009"
    timingCoding.display = time == "m" ? "Morning (qualifier value)" :
                           time == "d" ? "Noon (qualifier value)" :
                           time == "v" ? "Evening (qualifier value)" :
                           "Night time (qualifier value)"
    // Append the coding for timing to the array
    timingCodings.append(timingCoding)
    // Coding into the CodeableConcept
    timingCodeableConcept.coding = timingCodings
    // CodeableConcept text
    timingCodeableConcept.text = time == "m" ? "Morgens" :
                                 time == "d" ? "Mittags" :
                                 time == "v" ? "Abends" :
                                 "zur Nacht"
    // CodeableConcept into timing code
    timing.code = timingCodeableConcept
    // Timing into dosage
    dosage.timing = timing
    
    // asNeeded
    if quantityValue.lowercased().contains("bei bedarf") {
        dosage.asNeededBoolean = true
    } else {
        dosage.asNeededBoolean = false
    }
    
    if dosierEinheitCode != nil || dosierEinheitText != nil {
        // Dose and rate for the dosage
        let doseAndRate = DosageDoseAndRate()
        
        // Quantity for doseAndRate
        let quantity = Quantity()
        
        // Decorate the quantity
        quantity.system = FHIRURL("https://fhir.kbv.de/CodeSystem/KBV_CS_SFHIR_BMP_DOSIEREINHEIT")
        quantity.value = FHIRDecimal(quantityValue)
        
        if let einheit = dosierEinheitCode {
            quantity.unit = FHIRString(dosierEinheit[einheit] ?? "")
            quantity.code = FHIRString(einheit)
        } else if let text = dosierEinheitText {
            let extensionFHIR = Extension()
            extensionFHIR.url = "https://www.charite.de/fhir/medikationsplan/Extension/freitext"
            extensionFHIR.valueString = FHIRString(text)
            quantity.extension_fhir = [Extension]()
            quantity.extension_fhir?.append(extensionFHIR)
        }
        doseAndRate.doseQuantity = quantity
        dosage.doseAndRate = [doseAndRate]
        doseAndRate.doseQuantity = quantity
        dosage.doseAndRate = [doseAndRate]
    }
    
    if patInstruction != nil {
        dosage.patientInstruction = FHIRString(patInstruction!)
    }

    return dosage
}

/// Return an identifier with the given system and value
func getIdentifier(system: String, value: String) -> Identifier {
    let identifier = Identifier()
    identifier.system = FHIRURL(system)
    identifier.value = FHIRString(value)
    return identifier
}

/// Converts a string to FHIRDate
func getFHIRDate(date: String) -> FHIRDate {
    if date.count == 4 {
        return FHIRDate(year: Int(date)!, month: nil, day: nil)
    } else {
        return FHIRDate(string: "\(date.subString(from: 0, to: 4))-\(date.subString(from: 4, to: 6))-\(date.subString(from: 6, to: 8))")!
    }
}
