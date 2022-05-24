//
//  UKFUtility+Composition.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 23.03.22.
//

import Foundation
import FHIR

extension UKFUtility {
    // MARK: - Composition (P)
    static func medikationsplanToFHIR(medikationsplan: MedikationsPlanUKF) -> Composition {
        let compositionFHIR = Composition()
        // ID // TODO: 1..1
        compositionFHIR.id = FHIRString(medikationsplan.compositionID!)
        // Meta
        let compositionMeta = Meta()
        compositionMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/Composition")!]
        // Extension v Value
        let compositionExtension = Extension()
        compositionExtension.url = "https://www.charite.de/fhir/medikationsplan/Extension/medikationsplan-version"
        compositionExtension.valueString = FHIRString(medikationsplan.v)
        // Identifier U Value
        let identifier = Identifier()
        identifier.system = FHIRURL("https://www.charite.de/fhir/sid/medikationsplaene")
        identifier.value = FHIRString(medikationsplan.U.toUUID.lowercased())
        // l Value
        compositionFHIR.language = FHIRString(medikationsplan.l)
        
        // Type
        let compositionCodeableConcept = CodeableConcept()
        let compositionCoding = Coding()
        compositionCoding.system = FHIRURL("http://loinc.org")
        compositionCoding.code = "77603-9"
        compositionCodeableConcept.coding = [compositionCoding]
        
        // Title
        compositionFHIR.title = "Bundeseinheitlicher Medikationsplan"
        
        // Date Autor t Value
        compositionFHIR.date = DateTime(string: medikationsplan.A.t)
        
        // Decorate the resource
        compositionFHIR.status = .final
        compositionFHIR.meta = compositionMeta
        compositionFHIR.identifier = identifier
        compositionFHIR.extension_fhir = [compositionExtension]
        
        // Confidentiality
        compositionFHIR.confidentiality = "N"
        
        // Reference Subject
        let referenceSubject = Reference()
        referenceSubject.reference = FHIRString("Patient/\(medikationsplan.P.id!)")
        compositionFHIR.subject = referenceSubject
        
        // Reference Author
        let referenceAuthor = Reference()
        let resourceType = medikationsplan.A.lanr != nil ? "Practitioner" : "Organization"
        referenceAuthor.reference = FHIRString("\(resourceType)/\(medikationsplan.A.id!)")
        compositionFHIR.author = [referenceAuthor]
        
        // TODO: section
        var compositionSections = [CompositionSection]()
        // MARK: - medikationsplanSection
        var compositionSection = CompositionSection()
        // Code
        var compositionSectionCodeableConcept = CodeableConcept()
        var compositionSectionCoding = Coding()
        compositionSectionCoding.system = FHIRURL("http://loinc.org")
        compositionSectionCoding.code = "19009-0"
        compositionSectionCodeableConcept.coding = [compositionSectionCoding]
        compositionSection.code = compositionSectionCodeableConcept
        
        // Reference MedicationStatement List
        var compositionReferences = [Reference]()
        if medikationsplan.S != nil {
            for section in medikationsplan.S! {
                let compositionReference = Reference()
                compositionReference.reference = FHIRString("List/\(section.id!)")
                compositionReferences.append(compositionReference)
            }
            if compositionReferences.count != 0 {
                compositionSection.entry = compositionReferences
                compositionSections.append(compositionSection)
            }
        }

        // MARK: - allergienSection
        compositionSection = CompositionSection()
        // Code
        compositionSectionCodeableConcept = CodeableConcept()
        compositionSectionCoding = Coding()
        compositionSectionCoding.system = FHIRURL("http://loinc.org")
        compositionSectionCoding.code = "48765-2"
        compositionSectionCodeableConcept.coding = [compositionSectionCoding]
        compositionSection.code = compositionSectionCodeableConcept
        // Reference AllergyIntolerance
        compositionReferences = [Reference]()
        if medikationsplan.O != nil {
            if medikationsplan.O!.ai != nil {
                for id in medikationsplan.O!.aiID {
                    let compositionReference = Reference()
                    compositionReference.reference = FHIRString("https://www.charite.de/fhir/medikationsplan/StructureDefinition/AllergyIntolerance/\(id)")
                    compositionReferences.append(compositionReference)
                }
            }
            if compositionReferences.count != 0 {
                compositionSection.entry = compositionReferences
                compositionSections.append(compositionSection)
            }
        }

        // MARK: - gesundheitsBelange
        compositionSection = CompositionSection()
        // Code
        compositionSectionCodeableConcept = CodeableConcept()
        compositionSectionCoding = Coding()
        compositionSectionCoding.system = FHIRURL("http://loinc.org")
        compositionSectionCoding.code = "75310-3"
        compositionSectionCodeableConcept.coding = [compositionSectionCoding]
        compositionSection.code = compositionSectionCodeableConcept
        compositionReferences = [Reference]()
        if medikationsplan.O != nil {
            // Reference Schwangerschaft
            if medikationsplan.O!.p != nil {
                let compositionReference = Reference()
                compositionReference.reference = FHIRString("https://www.charite.de/fhir/medikationsplan/StructureDefinition/StatusSchwanger/\(medikationsplan.O!.pId!)")
                compositionReferences.append(compositionReference)
            }
            // Reference Stillzeit
            if medikationsplan.O!.b != nil {
                let compositionReference = Reference()
                compositionReference.reference = FHIRString("https://www.charite.de/fhir/medikationsplan/StructureDefinition/StatusStillend/\(medikationsplan.O!.bId!)")
                compositionReferences.append(compositionReference)
            }
            if compositionReferences.count != 0 {
                compositionSection.entry = compositionReferences
                compositionSections.append(compositionSection)
            }
        }
        
        // MARK: - klinischeParameter
        compositionSection = CompositionSection()
        // Code
        compositionSectionCodeableConcept = CodeableConcept()
        compositionSectionCoding = Coding()
        compositionSectionCoding.system = FHIRURL("http://loinc.org")
        compositionSectionCoding.code = "55752-0"
        compositionSectionCodeableConcept.coding = [compositionSectionCoding]
        compositionSection.code = compositionSectionCodeableConcept
        compositionReferences = [Reference]()
        if medikationsplan.O != nil {
            // Reference Köfpergewicht
            if medikationsplan.O!.w != nil {
                let compositionReference = Reference()
                compositionReference.reference = FHIRString("https://www.charite.de/fhir/medikationsplan/StructureDefinition/Koerpergewicht/\(medikationsplan.O!.wId!)")
                compositionReferences.append(compositionReference)
            }
            // Reference Körpergröße
            if medikationsplan.O!.h != nil {
                let compositionReference = Reference()
                compositionReference.reference = FHIRString("https://www.charite.de/fhir/medikationsplan/StructureDefinition/Koerpergroesse/\(medikationsplan.O!.hId!)")
                compositionReferences.append(compositionReference)
            }
            // Reference Kreatinin
            if medikationsplan.O!.c != nil {
                let compositionReference = Reference()
                compositionReference.reference = FHIRString("Observation/\(medikationsplan.O!.cId!)")
                compositionReferences.append(compositionReference)
            }
            if compositionReferences.count != 0 {
                compositionSection.entry = compositionReferences
                compositionSections.append(compositionSection)
            }
        }
        // MARK: - hinweiseSection TODO
        
        // Decorate the resource
        compositionFHIR.type = compositionCodeableConcept
        compositionFHIR.section = compositionSections
        return compositionFHIR
    }
}
