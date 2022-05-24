//
//  AutorUKF.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 06.09.21.
//

import Foundation

/// This is the struct for the author in UKF format CHECK
struct AutorUKF: Decodable, Hashable {
    /// ID des Practitioners
    var id: String?
    /// Name der aktuell ausdruckenden Person/Institution
    let n: String
    /// Straßenname und Hausnummer der aktuell ausdruckenden Person/Institutions
    let s: String?
    /// Postleitzahl des Ortes der aktuell ausdruckenden Person/Institution
    let z: String?
    /// Ort der aktuell ausdruckenden Person/Institution
    let c: String?
    /// Telefonnummer der aktuell ausdruckenden Person/Institution
    let p: String?
    /// E-Mail-Adresse der aktuell ausdruckenden Person/Institution
    let e: String?
    /// 9-stellige lebenslange Arztnummer (LANR). Optional, wenn zutreffend. Entweder lanr, idf oder kik darf angegeben werden.
    let lanr: String?
    /// 7-stellige Apothekenidentifikationsnummer. Optional, wenn zutreffend. Entweder lanr, idf oder kik darf angegeben werden.
    let idf: String?
    /// 9-stellige Krankenhausinstitutskennzeichen. Optional, wenn zutreffend. Entweder lanr, idf oder kik darf angegeben werden.
    let kik: String?
    /// Datum und Uhrzeit an dem der Medikationsplan ausgedruckt wurde.
    let t: String
}
