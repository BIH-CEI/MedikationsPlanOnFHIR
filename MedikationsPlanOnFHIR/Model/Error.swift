//
//  Error.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 10.05.22.
//

import Foundation

/// FHIR Errors
enum ErrorFHIR: Error {
    case medicationResourceNotFound
    case medicationPZNNotFound
    case patientResourceNotFound
    case orgResourceNotFound
    case practResourceNotFound
    case resourceNotUploaded
}

extension ErrorFHIR: CustomStringConvertible {
    /// Errors descriptions
    public var description: String {
        switch self {
        case .medicationPZNNotFound:
            return "PZN nicht gültig"
        case .medicationResourceNotFound:
            return "Medication Ressource wurde nicht gefunden"
        case .patientResourceNotFound:
            return "Patient Ressource wurde nicht gefunden"
        case .orgResourceNotFound:
            return "Organization Ressource wurde nicht gefunden"
        case .practResourceNotFound:
            return "Practitioner Ressource wurde nicht gefunden"
        case .resourceNotUploaded:
            return "Die Ressource konnte nicht hochgeladen werden"
        }
    }
}
