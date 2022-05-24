//
//  UKFUtility+Bundle.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 23.03.22.
//

import Foundation
import FHIR

extension UKFUtility {
        
    // MARK: - Transaction Bundle
    static func buildTransactionBundle(medikationsPlanUKF: MedikationsPlanUKF) {
        let bundle = FHIR.Bundle()
        bundle.type = .transaction
        var bundleEntrys = [BundleEntry]()

        // Entry
        var bundleEntry = BundleEntry()
        // Request
        var request = BundleEntryRequest()

        // MARK: - Observation
        if medikationsPlanUKF.O != nil {
            for observation in observationToFHIR(observation: medikationsPlanUKF.O!, patientID: medikationsPlanUKF.P.id!, issueDate: medikationsPlanUKF.A.t) {
                if observation.relativeURLBase() == "Observation" {
                    bundleEntry = BundleEntry()
                    // Request
                    request = BundleEntryRequest()
                    request.url = FHIRURL("Observation")
                    request.method = .POST
                    bundleEntry.request = request
                    // Resource
                    bundleEntry.resource = observation
                    bundleEntrys.append(bundleEntry)
                } else {
                    bundleEntry = BundleEntry()
                    // Request
                    request = BundleEntryRequest()
                    request.url = FHIRURL("AllergyIntolerance")
                    request.method = .POST
                    bundleEntry.request = request
                    // Resource
                    bundleEntry.resource = observation
                    bundleEntrys.append(bundleEntry)
                }
            }
        }

        // MARK: - Medication

        // Decorate the resource
        bundle.entry = bundleEntrys
        print(bundle.debugDescription)
    }
    
    // MARK: - Document Bundle
    static func buildDocumentBundle(medikationsPlanUKF: MedikationsPlanUKF) async {
        // Bundle FHIR
        let bundleFHIR = FHIR.Bundle()
        // Identifier
        let identifier = Identifier()
        identifier.system = FHIRURL("urn:ietf:rfc:3986")
        identifier.value = FHIRString("urn:uuid:\(medikationsPlanUKF.bundleID!)")
        bundleFHIR.identifier = identifier
        // Meta
        let bundleMeta = Meta()
        bundleMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/Bundle")!]
        // Bundle type
        bundleFHIR.type = .document
        // Timestamp
        bundleFHIR.timestamp = .now
        // TODO: Entry
        var bundleEntrys = [BundleEntry]()
        // MARK: - Composition Entry
        var bundleEntry = BundleEntry()
//        bundleEntry.resource = medikationsplanToFHIR(medikationsplan: medikationsPlanUKF)
//        bundleEntrys.append(bundleEntry)
//        // MARK: - Patient Entry
//        bundleEntry = BundleEntry()
//        bundleEntry.resource = patientToFHIR(patient: medikationsPlanUKF.P)
//        bundleEntrys.append(bundleEntry)
//        // MARK: - Autor Entry
//        bundleEntry = BundleEntry()
//        bundleEntry.resource = autorToFHIR(autor: medikationsPlanUKF.A)
//        bundleEntrys.append(bundleEntry)
//        // MARK: - Observation Entry
//        if medikationsPlanUKF.O != nil {
//            for resource in observationToFHIR(observation: medikationsPlanUKF.O!, patientID: medikationsPlanUKF.P.id!, issueDate: medikationsPlanUKF.A.t) {
//                bundleEntry = BundleEntry()
//                bundleEntry.resource = resource
//                bundleEntrys.append(bundleEntry)
//            }
//        }
        
        // MARK: - Medication Entry
        if let sections = medikationsPlanUKF.S {
            for list in await medicationStatementToFHIR(sections: sections, patientID: medikationsPlanUKF.P.id!) {
                bundleEntry = BundleEntry()
                bundleEntry.resource = list
                bundleEntrys.append(bundleEntry)
            }
            
            for section in sections {
                let resources = await UKFUtility.medicationStatementArr(medicationUKF: section.M!, patientID: medikationsPlanUKF.P.id!)
                for resource in resources {
                    bundleEntry = BundleEntry()
                    bundleEntry.resource = resource
                    bundleEntrys.append(bundleEntry)
                }
            }
        }
        
        // Decorate the bundle
        bundleFHIR.meta = bundleMeta
        bundleFHIR.entry = bundleEntrys
        print(bundleFHIR.debugDescription)
    }

}
