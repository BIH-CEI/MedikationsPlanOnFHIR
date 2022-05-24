//
//  PatientUKF.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 31.08.21.
//

import Foundation

/// This is the struct for the patient in UKF format CHECK
struct PatientUKF: Decodable, Hashable {
    /// ID des Patienten
    var id: String?
    /// Titel des Patienten, entsprechend der eGK- Spezifikation (VSD)
    let t: String?
    /// Vorname des Patienten, entsprechend der eGK-Spezifikation (VSD)
    let g: String
    /// Namenszusatz zum Namen des Patienten, entsprechend der eGK-Spezifikation (VSD)
    let z: String?
    /// Vorsatzwort zum Namen des Patienten, entsprechend der eGK-Spezifikation (VSD)
    let v: String?
    /// Nachname des Patienten, entsprechend der eGK-Spezifikation (VSD)
    let f: String
    /// Versicherten-ID, eindeutige lebenslange Identifikationsnummer des Patienten, entsprechend der eGK-Spezifikation (VSD)
    let egk: String?
    /*
     Geschlecht des Patienten - M oder
     - W oder
     - D oder
     - X
     Wenn nicht angegeben, muss das Attribut weggelassen werden.
     */
    let s: String?

    /// Geburtsdatum des Patienten, ggf. unvollständig, entsprechend der eGK- Spezifikation (VSD) Formate: YYYY-MM-DD, YYYY-MM (wenn Tag nicht bekannt), YYYY (wenn Monat und Tag nicht bekannt)
    let b: String
}
