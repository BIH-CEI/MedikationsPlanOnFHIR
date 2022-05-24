//
//  UKFUtility.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 31.08.21.
//

import Foundation
import XMLCoder
import FHIR

class UKFUtility {
    
    static func addUeberschrift(index: Int?, medikationsPlanFirst: inout MedikationsPlanUKF, section: Section) {
        if let index = index {
            if section.M != nil {
                if medikationsPlanFirst.S![index].M != nil {
                    medikationsPlanFirst.S![index].M!.append(contentsOf: section.M!)
                } else {
                    medikationsPlanFirst.S![index].M = section.M
                }
            }
        } else {
            medikationsPlanFirst.S!.append(section)
        }
    }
    
    /// Function to combine all the pages (array) to one element TODO: if bei let entfernen
    static func arrToObject(medikationsPlanArr: [MedikationsPlanUKF]) {
        let medikationsPlanArr = medikationsPlanArr
        // If there is just one element than return it
        if medikationsPlanArr.count == 1 {
            _Concurrency.Task {
                await createMedikationsPlanUKF(medikationsPlan: medikationsPlanArr[0])
            }
        } else { // All the other elements of the array gets combined to one TODO: Check double pages MP's | Use of guard let
            // The first element
            var medikationsPlanFirst = medikationsPlanArr[0]
            // Loop over all the elements except the first
            for medikationsPlan in medikationsPlanArr.dropFirst() {
                // Check if there is a Section in the element else return
                guard let sections = medikationsPlan.S else {
                    return
                }
                // Loop over all sections on the page
                for section in sections {
                    // If "Freitextzwischenüberschrift" is present
                    if section.t != nil {
                        let index = medikationsPlanFirst.S!.firstIndex(where: { $0.t == section.t })
                        addUeberschrift(index: index, medikationsPlanFirst: &medikationsPlanFirst, section: section)
                    // Else if "Standardzwischenüberschrift" is present
                    } else if section.c != nil {
                        let index = medikationsPlanFirst.S!.firstIndex(where: { $0.c == section.c })
                        addUeberschrift(index: index, medikationsPlanFirst: &medikationsPlanFirst, section: section)
                    // Else - Create a new one
                    } else {
                        let index = medikationsPlanFirst.S!.firstIndex(where: { $0.t == nil && $0.c == nil })
                        // TODO: Check this one
                        addUeberschrift(index: index, medikationsPlanFirst: &medikationsPlanFirst, section: section)
                    }
                }
            }
            
            let newMedikationsPlan = MedikationsPlanUKF.init(v: medikationsPlanFirst.v,
                                                             U: medikationsPlanFirst.U,
                                                             a: nil,
                                                             z: nil,
                                                             l: medikationsPlanFirst.l,
                                                             bundleID: nil,
                                                             compositionID: nil,
                                                             P: medikationsPlanFirst.P,
                                                             A: medikationsPlanFirst.A,
                                                             O: medikationsPlanFirst.O!,
                                                             S: medikationsPlanFirst.S!)
            
            _Concurrency.Task {
                await createMedikationsPlanUKF(medikationsPlan: newMedikationsPlan)
            }
        }
    }
    
    // MARK: - Decodes the XML into the MedikationsPlanUKF Struct
    static func buildMedikationsPlanUKF(data: String) -> MedikationsPlanUKF? {
        return try? XMLDecoder().decode(MedikationsPlanUKF.self, from: Data(data.utf8))
    }
    
    // MARK: - MedikationsPlan (MP)
    @MainActor static func createMedikationsPlanUKF(medikationsPlan: MedikationsPlanUKF) async {
        MPVM.shared.fetching = true
        var medikationsPlan = medikationsPlan
        // Check if the patient and autor are on server
        do {
            // Set the UUID's of the patient resource
            medikationsPlan.P.id = try await SMARTClient.shared.getPatientID(patientUKF: medikationsPlan.P)
            // Set the UUID's of the practitioner resource
            medikationsPlan.A.id = try await SMARTClient.shared.getAutorID(autorUKF: medikationsPlan.A)
        } catch {
            MPVM.shared.fetching = false
            MPVM.shared.errorMessage = (error as CustomStringConvertible).description
            MPVM.shared.errorBool = true
            return
        }
        
        // Set the UUID's of the bundle resource
        medikationsPlan.bundleID = UUID().uuidString.lowercased()
        // Set the UUID's of the composition resource
        medikationsPlan.compositionID = UUID().uuidString.lowercased()
        // Set the UUID's of the observation resource
        if let observations = medikationsPlan.O {
            if let ais = observations.ai {
                for _ in ais.components(separatedBy: ",") {
                    medikationsPlan.O!.aiID.append(UUID().uuidString.lowercased())
                }
            }
            if observations.p != nil {
                medikationsPlan.O!.pId = UUID().uuidString.lowercased()
            }
            if observations.b != nil {
                medikationsPlan.O!.bId = UUID().uuidString.lowercased()
            }
            if observations.w != nil {
                medikationsPlan.O!.wId = UUID().uuidString.lowercased()
            }
            if observations.h != nil {
                medikationsPlan.O!.hId = UUID().uuidString.lowercased()
            }
            if observations.c != nil {
                medikationsPlan.O!.cId = UUID().uuidString.lowercased()
            }
        }
        
        // Fill medication names by using the pzn's
        if medikationsPlan.S != nil {
            for (indexSection, _) in medikationsPlan.S!.enumerated() {
                // Set a new UUID
                medikationsPlan.S![indexSection].id = UUID().uuidString.lowercased()
                
                // Check if there is a Medication array in the section else continue to the next section
                guard let medicationArr = medikationsPlan.S![indexSection].M else {
                    continue
                }
                
                // Loop over all the medication elements
                for (index, _) in medicationArr.enumerated() {
                    // Set a new UUID for identifying the element
                    medikationsPlan.S![indexSection].M![index].id = UUID()
                    // If the pzn of the medication is nill then continue to the next element
                    guard let pzn = medikationsPlan.S![indexSection].M![index].p else {
                        continue
                    }
                    
                    // If the name of the medication is nill then fill it up and continue
                    guard let _ = medikationsPlan.S![indexSection].M![index].a else {
                        do {
                            medikationsPlan.S![indexSection].M![index].a = try await SMARTClient.shared.getMedicationName(pzn: pzn)
                        } catch {
                            MPVM.shared.fetching = false
                            MPVM.shared.errorMessage = (error as CustomStringConvertible).description
                            MPVM.shared.errorBool = true
                            return
                        }
                        continue
                    }
                }
            }
        }
        MPVM.shared.medikationsPlanArr.append(medikationsPlan)
        MPVM.shared.fetching = false
    }
    
    @MainActor static func uploadMedikationsplan(medikationsPlanUKF: MedikationsPlanUKF) async {
        MPVM.shared.fetching = true
        let patientID = medikationsPlanUKF.P.id!
        var uploadedQueue = [Resource]()
        do {
            // MARK: - Observations
            if let observations = medikationsPlanUKF.O {
                for observation in observationToFHIR(observation: observations,
                                                     patientID: patientID,
                                                     issueDate: medikationsPlanUKF.A.t) {

                    _ = try await SMARTClient.shared.sendResource(resource: observation)
                    uploadedQueue.append(observation)
                }
                
            }
            // MARK: - Medication
//            if let section = medikationsPlanUKF.S {
//                for (indexSection, _) in section.enumerated() {
//                    // Check if there is a Medication array in the section else continue to the next section
//                    guard let medicationArr = medikationsPlanUKF.S![indexSection].M else {
//                        continue
//                    }
//
//                    // Loop over all the medication elements
//                    for (index, _) in medicationArr.enumerated() {
//                        let pzn = medikationsPlanUKF.S![indexSection].M![index].p!
//                        let medicationResource = try await SMARTClient.shared.getMedicationResource(pzn: pzn)
//                        _ = try await SMARTClient.shared.sendResource(resource: medicationResource)
//                        uploadedQueue.append(medicationResource)
//                    }
//                }
//
//            }
            // MARK: - MedicationStatement
            if let sections = medikationsPlanUKF.S {
                    for section in sections {
                        
                        guard let medicationArr = section.M else {
                            continue
                        }
                        
                        let medicationStatementArr = await UKFUtility.medicationStatementArr(medicationUKF: medicationArr, patientID: patientID)
                        
                        for medicationStatement in medicationStatementArr {
                            print(medicationStatement.debugDescription)
                            _ = try await SMARTClient.shared.sendResource(resource: medicationStatement)
                            uploadedQueue.append(medicationStatement)
                        }
                    }
             }
                
            
            // MARK: - MedicationList
        } catch {
            for resource in uploadedQueue {
                do {
                    _ = try await SMARTClient.shared.deleteResource(resource: resource)
                } catch {
                    print(error)
                }
               
            }
            MPVM.shared.fetching = false
            MPVM.shared.errorMessage = (error as CustomStringConvertible).description
            MPVM.shared.errorBool = true
        }
        MPVM.shared.fetching = false
    }
}
