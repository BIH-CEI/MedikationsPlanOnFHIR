//
//  UKFUtility+Observation.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 23.03.22.
//

import Foundation
import FHIR

extension UKFUtility {
    // MARK: - Observation (O)
    static func observationToFHIR(observation: ObservationUKF, patientID: String, issueDate: String) -> [Resource] {
        // Resource to be returned
        var observationsFHIR = [Resource]()
        
        // w Value
        if observation.w != nil {
            let observationFHIR = Observation()
            // id
            observationFHIR.id = FHIRString(observation.wId!)

            // Meta
            let observationMeta = Meta()
            observationMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/Koerpergewicht")!]

            // Category
            let observationCodeableConceptCategory = CodeableConcept()
            var observationCoding = Coding()
            observationCoding.system = FHIRURL("http://terminology.hl7.org/CodeSystem/observation-category")
            observationCoding.code = "vital-signs"
            observationCodeableConceptCategory.coding = [observationCoding]

            // Code
            let observationCodeableConceptCode = CodeableConcept()
            var observationCodings = [Coding]()
            observationCoding = Coding()
            observationCoding.system = FHIRURL("http://loinc.org")
            observationCoding.code = "29463-7"
            observationCoding.display = "Body weight"
            observationCodings.append(observationCoding)
            observationCoding = Coding()
            observationCoding.system = FHIRURL("http://snomed.info/sct")
            observationCoding.code = "27113001"
            observationCoding.display = "Body weight"
            observationCodings.append(observationCoding)
            observationCodeableConceptCode.coding = observationCodings
            observationCodeableConceptCode.text = "Körpergewicht"

            // Subject
            let referenceSubject = Reference()
            referenceSubject.reference = FHIRString("Patient/\(patientID)")

            // EffectiveDateTime
            observationFHIR.effectiveDateTime = DateTime.init(string: issueDate)

            // ValueQuantity
            let quantity = Quantity()
            quantity.value = FHIRDecimal(observation.w!)
            quantity.unit = "kilogram"
            quantity.system = FHIRURL("http://unitsofmeasure.org")
            quantity.code = "kg"

            // Decorate the observation
            observationFHIR.meta = observationMeta
            observationFHIR.status = .final
            observationFHIR.category = [observationCodeableConceptCategory]
            observationFHIR.code = observationCodeableConceptCode
            observationFHIR.valueQuantity = quantity
            observationFHIR.subject = referenceSubject

            observationsFHIR.append(observationFHIR)
        }

        // h Value
        if observation.h != nil {
            let observationFHIR = Observation()
            // id
            observationFHIR.id = FHIRString(observation.hId!)

            // Meta
            let observationMeta = Meta()
            observationMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/Koerpergroesse")!]

            // Category
            let observationCodeableConceptCategory = CodeableConcept()
            var observationCoding = Coding()
            observationCoding.system = FHIRURL("http://terminology.hl7.org/CodeSystem/observation-category")
            observationCoding.code = "vital-signs"
            observationCodeableConceptCategory.coding = [observationCoding]

            // Code
            let observationCodeableConceptCode = CodeableConcept()
            var observationCodings = [Coding]()
            observationCoding = Coding()
            observationCoding.system = FHIRURL("http://loinc.org")
            observationCoding.code = "8302-2"
            observationCoding.display = "Body height"
            observationCodings.append(observationCoding)
            observationCoding = Coding()
            observationCoding.system = FHIRURL("http://snomed.info/sct")
            observationCoding.code = "50373000"
            observationCoding.display = "Body height measure"
            observationCodings.append(observationCoding)
            observationCodeableConceptCode.coding = observationCodings
            observationCodeableConceptCode.text = "Körpergröße"

            // Subject
            let referenceSubject = Reference()
            referenceSubject.reference = FHIRString("Patient/\(patientID)")

            // EffectiveDateTime
            observationFHIR.effectiveDateTime = DateTime.init(string: issueDate)

            // ValueQuantity
            let quantity = Quantity()
            quantity.value = FHIRDecimal(observation.h!)
            quantity.unit = "centimeter"
            quantity.system = FHIRURL("http://unitsofmeasure.org")
            quantity.code = "cm"

            // Decorate the observation
            observationFHIR.meta = observationMeta
            observationFHIR.status = .final
            observationFHIR.category = [observationCodeableConceptCategory]
            observationFHIR.code = observationCodeableConceptCode
            observationFHIR.valueQuantity = quantity
            observationFHIR.subject = referenceSubject

            observationsFHIR.append(observationFHIR)
        }

        // c Value
        if observation.c != nil {
            let observationFHIR = Observation()
            // id
            observationFHIR.id = FHIRString(observation.cId!)

            // Meta
            let observationMeta = Meta()
            observationMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/Kreatininwert")!]

            // Code
            let observationCodeableConceptCode = CodeableConcept()
            let observationCoding = Coding()
            observationCoding.system = FHIRURL("http://loinc.org")
            observationCoding.code = "2160-0"
            observationCoding.display = "Creatinine [Mass/Vol]"
            observationCodeableConceptCode.coding = [observationCoding]
            observationCodeableConceptCode.text = "Kreatinin"

            // Subject
            let referenceSubject = Reference()
            referenceSubject.reference = FHIRString("Patient/\(patientID)")

            // EffectiveDateTime
            observationFHIR.effectiveDateTime = DateTime.init(string: issueDate)

            // ValueQuantity
            let quantity = Quantity()
            quantity.value = FHIRDecimal(observation.c!)
            quantity.unit = "mg/dl"
            quantity.system = FHIRURL("http://unitsofmeasure.org")
            quantity.code = "mg/dl"

            // Decorate the observation
            observationFHIR.meta = observationMeta
            observationFHIR.status = .final
            observationFHIR.code = observationCodeableConceptCode
            observationFHIR.valueQuantity = quantity
            observationFHIR.subject = referenceSubject
            observationsFHIR.append(observationFHIR)
        }

        // ai Value
        if observation.ai != nil {
            let ais = observation.ai!.components(separatedBy: ",")
            for element in ais {
                let allergyIntoleranceFHIR = AllergyIntolerance()
                // Meta
                let allergyIntoleranceMeta = Meta()
                allergyIntoleranceMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/AllergyIntolerance")!]
                // Code
                let allergyIntoleranceCodeableConcept = CodeableConcept()
                allergyIntoleranceCodeableConcept.text = FHIRString(element.noWhiteSpaces)
                // Clinical Status
                let clinicalStatusCodeableConcept = CodeableConcept()
                let clinicalStatusCoding = Coding()
                clinicalStatusCoding.system = FHIRURL("http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical")
                clinicalStatusCoding.code = "active"
                clinicalStatusCodeableConcept.coding = [clinicalStatusCoding]
                
                // Reference Subject
                let referencePatient = Reference()
                referencePatient.reference = FHIRString("Patient/\(patientID)")
                
                // Decorate the resource
                allergyIntoleranceFHIR.meta = allergyIntoleranceMeta
                allergyIntoleranceFHIR.code = allergyIntoleranceCodeableConcept
                allergyIntoleranceFHIR.clinicalStatus = clinicalStatusCodeableConcept
                allergyIntoleranceFHIR.patient = referencePatient
                
                observationsFHIR.append(allergyIntoleranceFHIR)
            }
        }

        // p Value
        if observation.p != nil {
            let observationFHIR = Observation()
            // id
            observationFHIR.id = FHIRString(observation.pId!)

            // Meta
            let observationMeta = Meta()
            observationMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/StatusSchwanger")!]

            // Code
            let observationCodeableConceptCode = CodeableConcept()
            let observationCoding = Coding()
            observationCoding.system = FHIRURL("http://loinc.org")
            observationCoding.code = "82810-3"
            observationCoding.display = "Schwangerschaftsstatus"
            observationCodeableConceptCode.coding = [observationCoding]

            // Subject
            let referenceSubject = Reference()
            referenceSubject.reference = FHIRString("Patient/\(patientID)")

            // EffectiveDateTime
            observationFHIR.effectiveDateTime = DateTime.init(string: issueDate)

            // ValueCodeableConcept
            let valueCodeableConcept = CodeableConcept()
            let valueCoding = Coding()
            valueCoding.system = FHIRURL("http://hl7.org/fhir/uv/ips/ValueSet/pregnancy-status-uv-ips")
            valueCoding.code = observation.p! == "1" ? "LA15173-0" : "LA26683-5"
            valueCoding.display = observation.p! == "1" ? "Pregnant" : "Not pregnant"
            valueCodeableConcept.text = observation.p! == "1" ? "Pregnant" : "Not pregnant"
            valueCodeableConcept.coding = [valueCoding]
            
            // Decorate the observation
            observationFHIR.meta = observationMeta
            observationFHIR.status = .final
            observationFHIR.code = observationCodeableConceptCode
            observationFHIR.valueCodeableConcept = valueCodeableConcept
            observationFHIR.subject = referenceSubject
            
            observationsFHIR.append(observationFHIR)
        }

        // b Value
        if observation.b != nil {
            let observationFHIR = Observation()
            // id
            observationFHIR.id = FHIRString(observation.bId!)
            // Meta
            let observationMeta = Meta()
            observationMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/StatusStillend")!]
            
            // CodeableConcept
            let observationCodeableConcept = CodeableConcept()
            let observationCoding = Coding()
            observationCoding.system = FHIRURL("http://loinc.org")
            observationCoding.code = "63895-7"
            observationCodeableConcept.coding = [observationCoding]

            // Value
            observationFHIR.valueBoolean = observation.b! == "1" ? true : false
            
            // Subject
            let referenceSubject = Reference()
            referenceSubject.reference = FHIRString("Patient/\(patientID)")

            // EffectiveDateTime
            observationFHIR.effectiveDateTime = DateTime.init(string: issueDate)
            
            // Decorate the resource
            observationFHIR.meta = observationMeta
            observationFHIR.status = .final
            observationFHIR.code = observationCodeableConcept
            observationFHIR.subject = referenceSubject
            observationsFHIR.append(observationFHIR)
        }

        // x Value
        if observation.x != nil {
            let observationFHIR = Observation()
            // Meta
            let observationMeta = Meta()
            observationMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/freitext")!]
            
            // CodeableConcept
            let observationCodeableConcept = CodeableConcept()
            let observationCoding = Coding()
            observationCoding.system = FHIRURL("http://loinc.org")
            observationCoding.code = "86467-8"
            observationCodeableConcept.coding = [observationCoding]
            
            // Value
            observationFHIR.valueString = FHIRString(observation.x!)
            
            // Subject
            let referenceSubject = Reference()
            referenceSubject.reference = FHIRString("Patient/\(patientID)")

            // EffectiveDateTime
            observationFHIR.effectiveDateTime = DateTime.init(string: issueDate)
            
            // Decorate the resource
            observationFHIR.meta = observationMeta
            observationFHIR.status = .final
            observationFHIR.code = observationCodeableConcept
            observationFHIR.subject = referenceSubject
            observationsFHIR.append(observationFHIR)
        }
        
        return observationsFHIR
    }
}
