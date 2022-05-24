//
//  UKFUtility+Medication.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 23.03.22.
//

import Foundation
import FHIR

extension UKFUtility {
    
    // MARK: - Medication
    static func medicationStatementToFHIR(sections: [Section], patientID: String) async -> [List] {
        // Lists FHIR
        var listsFHIR = [List]()
        
        for section in sections {
            // List FHIR
            let listFHIR = List()
            // ID FHIR
            listFHIR.id = FHIRString(section.id!)
            // List Meta
            let listMeta = Meta()
            listMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/List")!]
            listFHIR.meta = listMeta
            // List Status
            listFHIR.status = .current
            // List Mode
            listFHIR.mode = .snapshot
            // List Entry
            var listEntry = [ListEntry]()
            
            
            // c Value
            if section.c != nil {
                let listCodeableConcept = CodeableConcept()
                let listCoding = Coding()
                listCoding.system = FHIRURL("https://www.charite.de/fhir/medikationsplan/CodeSystem/kbv/s-bmp-zwischenueberschrift")
                listCoding.code = FHIRString(section.c!)
                listCodeableConcept.coding = [listCoding]
                // Dictionary
                let title = zwischenUeberschrift[section.c!]!
                listCodeableConcept.text = FHIRString(title)
                listFHIR.code = listCodeableConcept
                listFHIR.title = FHIRString(title)
                // t Value
            } else if section.t != nil {
                let listCodeableConcept = CodeableConcept()
                listCodeableConcept.text = FHIRString(section.t!)
                listFHIR.title = FHIRString(section.t!)
            }
            
            
            
            if section.M != nil {
                let medicationStatementArr = await medicationStatementArr(medicationUKF: section.M!, patientID: patientID)
                for medicationStatement in medicationStatementArr {
                    let listEntryItem = ListEntry()
                    let referenceMedicationStatement = Reference()
                    referenceMedicationStatement.reference = FHIRString("MedicationStatement/\(medicationStatement.id!)")
                    listEntryItem.item = referenceMedicationStatement
                    listEntry.append(listEntryItem)
                }
            }
            
            // Decorate the List resource
            listFHIR.meta = listMeta
            listFHIR.entry = listEntry
            // Output
            listsFHIR.append(listFHIR)
        }
                
        return listsFHIR
    }
    
    
    static func medicationStatementArr(medicationUKF: [Medication], patientID: String) async -> [MedicationStatement] {
        var medicationStatementList = [MedicationStatement]()
        for medication in medicationUKF {
            // MedicationStament resource
            let medicationStamentFHIR = MedicationStatement()
            // id
            medicationStamentFHIR.id = FHIRString(UUID().uuidString.lowercased())
            // Dosage array
            var dosages = [Dosage]()
            // Meta
            let medicationStatementMeta = Meta()
            medicationStatementMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/MedicationStatement")!]

            // p Value
            if medication.p != nil {
                print("Enter p")
                do {
                    let resource = try await SMARTClient.shared.getMedicationResource(pzn: medication.p!)
                    medicationStamentFHIR.medicationReference = try? medicationStamentFHIR.reference(resource: resource)
                } catch {
                    print(error)
                }
            }
            print("End p")

            // a Value TODO: Useless
            if medication.a != nil {
                
            }
            
            // f and fd Value TODO: Big data
            
            // m Value
            var dosage = Dosage()
            if medication.m != nil {
                dosages.append(getDosage(quantityValue: medication.m!, time: "m", dosierEinheitCode: medication.du, dosierEinheitText: medication.dud, patInstruction: medication.i))
            }
            // d Value
            if medication.d != nil {
                dosages.append(getDosage(quantityValue: medication.d!, time: "d", dosierEinheitCode: medication.du, dosierEinheitText: medication.dud,patInstruction: medication.i))
            }
            // v Value
            if medication.v != nil {
                dosages.append(getDosage(quantityValue: medication.v!, time: "v", dosierEinheitCode: medication.du, dosierEinheitText: medication.dud,patInstruction: medication.i))
            }
            // h Value
            if medication.h != nil {
                dosages.append(getDosage(quantityValue: medication.h!, time: "h", dosierEinheitCode: medication.du, dosierEinheitText: medication.dud,patInstruction: medication.i))
            }
            
            // t Value
            if medication.t != nil {
                dosage = Dosage()
                dosage.text = FHIRString(medication.t!)
                dosages.append(dosage)
            }
            
            // r Value
            if medication.r != nil {
                let codeableCondept = CodeableConcept()
                codeableCondept.text = FHIRString(medication.r!)
                medicationStamentFHIR.reasonCode = [codeableCondept]
            }

            // subject reference
            let referenceSubject = Reference()
            referenceSubject.reference = FHIRString("Patient/\(patientID)")
            
            // Decorate the resource
            medicationStamentFHIR.meta = medicationStatementMeta
            medicationStamentFHIR.dosage = dosages
            medicationStamentFHIR.subject = referenceSubject
            medicationStamentFHIR.status = .active

            medicationStatementList.append(medicationStamentFHIR)
        }
        return medicationStatementList
    }
}
