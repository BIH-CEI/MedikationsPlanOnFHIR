//
//  SMARTClient.swift
//  ECGSmart
//
//  Created by Alonso Essenwanger on 07.09.21.
//

import Foundation
import SMART
import FHIR
import AVFoundation
import os

/// The SMARTClient handles all the operations for the comunication with the server
class SMARTClient {
    /// Singleton
    static let shared = SMARTClient()
    /// The url of the Keycloak server
    let keycloakURL = ""
    /// The url of the FHIR server
    let fhirURL = ""
    /// The Client
    var smart: Client
    
    /// Constructor
    init() {
        smart = Client(
            baseURL: URL(string: fhirURL)!,
            settings: [
                "client_id": "cei_vonk",
                "scope": "openid",
                "redirect": "medikationsplanxml://callback",
                "verbose": true,
                "authorize_uri": "\(keycloakURL)/auth/realms/Test/protocol/openid-connect/auth",
                "token_uri": "\(keycloakURL)/auth/realms/Test/protocol/openid-connect/token",
            ]
        )
        smart.authProperties.embedded = true
        smart.authProperties.granularity = .tokenOnly
        print("SMARTClient init: ID Token: \(String(describing: smart.server.idToken)) ")
        print("SMARTClient init: Refresh Token  \(String(describing: smart.server.refreshToken))")
    }
        
    /// This function authorizes the user using the SMART library
    func auth() async throws -> Bool {
        print("SMARTClient auth():")
        return try await withCheckedThrowingContinuation { continuation in
            smart.authorize { _, error in
                print("SMARTClient auth(): Closure start")
                if error != nil {
                    print("SMARTClient auth(): Error \(error!)")
                    continuation.resume(throwing: error!)
                } else {
                    print("SMARTClient auth(): Auth succesfull")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    /// This functions sends the given resource to the FHIR server
    func sendResource(resource: Resource) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            resource._server = self.smart.server
            resource.update { error in
                if error != nil {
                    continuation.resume(throwing: error!)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    /// This functions deletes the given resource of the FHIR server
    func deleteResource(resource: Resource) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            resource._server = self.smart.server
            resource.delete { error in
                if error != nil {
                    continuation.resume(throwing: error!)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    /// This function returns the patient ID by using the birthdate and identifier of the given PatientUKF
    func getPatientID(patientUKF: PatientUKF) async throws -> String {
        let birthdate = getFHIRDate(date: patientUKF.b)
        let gkv = patientUKF.egk
        let search = ["birthdate": birthdate.description, "identifier": gkv]
        // Patient.search(["address": "Boston", "gender": "male", "given": ["$exact": "Willis"]])
        let patientSearch = Patient.search(search)
        var output = ""
        return try await withCheckedThrowingContinuation { continuation in
            patientSearch.perform(SMARTClient.shared.smart.server) { bundle, error in
                if error != nil {
                    print("SMARTClient: getPatient Error: \(error!)")
                    continuation.resume(throwing: error!)
                } else {
                    print("SMARTClient: getPatient")
                    let bundleEntry = bundle?.entry?
                        .filter { $0.resource is FHIR.Patient }
                        .map { $0.resource as! FHIR.Patient }
                    if bundleEntry != nil {
                        output = bundleEntry![0].id!.string
                        continuation.resume(returning: output)
                    } else {
                        continuation.resume(throwing: ErrorFHIR.patientResourceNotFound)
                    }
                }
            }
        }
    }
    
    /// This function returns the autor ID by using the identifier of the given AutorUKF
    func getAutorID(autorUKF: AutorUKF) async throws -> String {
        let lanr = autorUKF.lanr
        let idf = autorUKF.idf
        let kik = autorUKF.kik
        
        let search = ["identifier": lanr != nil ? lanr!.description :
                                    idf  != nil ? idf!.description :
                                    kik!.description]
        
        let autorSearch = lanr != nil ? Practitioner.search(search) : Organization.search(search)

        var output = ""
        
        return try await withCheckedThrowingContinuation { continuation in
            autorSearch.perform(SMARTClient.shared.smart.server) { bundle, error in
                if error != nil {
                    print("SMARTClient: getAutorID Error: \(error!)")
                    continuation.resume(throwing: error!)
                } else {
                    print("SMARTClient: getAutorID")
                    // lanr
                    if lanr != nil {
                        let bundleEntry = bundle?.entry?
                            .filter { $0.resource is FHIR.Practitioner}
                            .map { $0.resource as! FHIR.Practitioner }
                        if bundleEntry != nil {
                            output = bundleEntry![0].id!.string
                            continuation.resume(returning: output)
                        } else {
                            continuation.resume(throwing: ErrorFHIR.practResourceNotFound)
                        }
                    // kik or idf
                    } else {
                        let bundleEntry = bundle?.entry?
                            .filter { $0.resource is FHIR.Organization}
                            .map { $0.resource as! FHIR.Organization }
                        if bundleEntry != nil {
                            output = bundleEntry![0].id!.string
                            continuation.resume(returning: output)
                        } else {
                            continuation.resume(throwing: ErrorFHIR.orgResourceNotFound)
                        }
                    }
                }
            }
        }
    }
    
    // TODO use the url variable for the search request
    /// This function will request the pzn using a FHIR Search. When a Medication is found with the pzn, then the function will return the name of the pzn as String
    func getMedicationName(pzn: String) async throws -> String? {
//        let url = "http://fhir.de/CodeSystem/ifa/pzn"
        let search = ["code": pzn]
        let medication = FHIR.Medication.search(search)
        var output = ""
        return try await withCheckedThrowingContinuation { continuation in
            medication.perform(SMARTClient.shared.smart.server) { bundle, error in
                if error != nil {
                    print("SMARTClient: getMedicationName Error: \(error!)")
                    continuation.resume(throwing: error!)
                } else {
                    print("SMARTClient: getMedicationName")
                    let bundleEntry = bundle?.entry?
                        .filter { $0.resource is FHIR.Medication }
                        .map { $0.resource as! FHIR.Medication }
                    if bundleEntry != nil {
                        output = bundleEntry![0].code!.text!.string
                        continuation.resume(returning: output)
                    } else {
                        continuation.resume(throwing: ErrorFHIR.medicationPZNNotFound)
                    }
                }
            }
        }
    }
        
    func getMedicationResource(pzn: String) async throws -> FHIR.Medication {
//        let url = "http://fhir.de/CodeSystem/ifa/pzn"
        let search = ["code": pzn]
        let medication = FHIR.Medication.search(search)
        
        return try await withCheckedThrowingContinuation { continuation in
            medication.perform(SMARTClient.shared.smart.server) { bundle, error in
                if error != nil {
                    print("SMARTClient: getMedicationResource Error: \(error!)")
                    continuation.resume(throwing: error!)
                } else {
                    print("SMARTClient: getMedicationResource")
                    let name = bundle?.entry?
                        .filter { $0.resource is FHIR.Medication }
                        .map { $0.resource as! FHIR.Medication }
                    if name != nil {
                        continuation.resume(returning: name![0])
                    } else {
                        continuation.resume(throwing: ErrorFHIR.medicationResourceNotFound)
                    }
                }
            }
        }
    }
}
