//
//  UKFUtility+Patient.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 23.03.22.
//

import Foundation
import FHIR

extension UKFUtility {
    // MARK: - Patient (P) DONE
    static func patientToFHIR(patient: PatientUKF) -> Patient {
        // Patient FHIR
        let patientFHIR = Patient()
        // Resource ID
        patientFHIR.id = FHIRString(patient.id!)
        // Name
        let humanName = HumanName()
        humanName.use = NameUse.official
        // Meta
        let patientMeta = Meta()
        patientMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/Patient")!]

        // t Value
        if patient.t != nil {
            let prefixExtension = Extension()
            prefixExtension.url = FHIRString("http://hl7.org/fhir/StructureDefinition/iso21090-EN-qualifier")
            prefixExtension.valueCode = FHIRString("AC")
            var prefixValues = FHIRString(patient.t!.noWhiteSpaces)
            prefixValues.extension_fhir = [prefixExtension]
            humanName.prefix = [prefixValues]
        }

        // g Value
        var givenName = patient.g.components(separatedBy: " ").map { FHIRString($0) }
        givenName.removeAll{ $0.isEmpty }
        humanName.given = givenName
        
        // f Value
        humanName.family = FHIRString(patient.f.noWhiteSpaces)
        humanName.family!.extension_fhir = [Extension]()
        let familyExtension = Extension()
        familyExtension.url = FHIRString("http://hl7.org/fhir/StructureDefinition/humanname-own-name")
        familyExtension.valueString = FHIRString(humanName.family!.string)
        humanName.family!.extension_fhir?.append(familyExtension)
        humanName.text = FHIRString("\(patient.t ?? "") \(patient.g) \(patient.z ?? "") \(patient.v ?? "")  \(patient.f)")
        
        // z Value
        if patient.z != nil {
            let namenZusatzExtension = Extension()
            namenZusatzExtension.url = FHIRString("http://fhir.de/StructureDefinition/humanname-namenszusatz")
            namenZusatzExtension.valueString = FHIRString(patient.z!.noWhiteSpaces)
            humanName.family?.extension_fhir?.append(namenZusatzExtension)
        }

        // v Value
        if patient.v != nil {
            let vorsatzWortExtension = Extension()
            vorsatzWortExtension.url = FHIRString("http://hl7.org/fhir/StructureDefinition/humanname-own-prefix")
            vorsatzWortExtension.valueString = FHIRString(patient.v!)
            humanName.family?.extension_fhir?.append(vorsatzWortExtension)
        }
        
        // eGk Value
        if patient.egk != nil {
            let typeCoding = Coding()
            typeCoding.system = FHIRURL("http://fhir.de/CodeSystem/identifier-type-de-basis")
            typeCoding.code = "GKV"
            let typeCodeableConcept = CodeableConcept()
            typeCodeableConcept.coding = [typeCoding]
            
            let patientIdentifier = Identifier()
            patientIdentifier.use = .official
            patientIdentifier.type = typeCodeableConcept
            patientIdentifier.system = FHIRURL("http://fhir.de/sid/gkv/kvid-10")
            patientIdentifier.value = FHIRString(patient.egk!.noWhiteSpaces)
            patientFHIR.identifier = [patientIdentifier]
        }
        
        // s Value
        if patient.s != nil {
            switch patient.s {
            case "M":
                patientFHIR.gender = AdministrativeGender.male
            case "W":
                patientFHIR.gender = AdministrativeGender.female
            case "D":
                patientFHIR.gender = AdministrativeGender.other
            default:
                patientFHIR.gender = AdministrativeGender.unknown
            }
        }
        
        // b Value TODO: Check alternative of writing this
        patientFHIR.birthDate = getFHIRDate(date: patient.b)
        
        // Decorate the resource
        patientFHIR.name = [humanName]
        patientFHIR.meta = patientMeta
        return patientFHIR
    }
}
