//
//  MedikationsPlanUKF.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 19.10.21.
//

import Foundation
import Models

/// Root-Element (Bundle+Composition): Medikationsplan Ultrakurzformat CHECK
struct MedikationsPlanUKF: Decodable, Hashable {
    /// Versionsnummer der Spezifikation des Medikationsplans. Format xxy, beim Druck wird aus 022 eine 2.2
    let v: String
    /// Die Instanz-ID ist eine GUID (Global Unique Identifier), die bei jeder Erstellung eines Medikationsplans (mit oder ohne Planänderung) neu erzeugt wird. Auf jeder Seite eines mehrseitigen Plans ist die gleiche Instanz-ID im Carrier enthalten.
    let U: String
    /// Aktuelle Seite, mit 1 startend; muss bei mehrseitigen Plänen auf jeder Seite im Carrier verwendet werden; bei einseitigem Plan muss es weggelassen werden.
    let a: String?
    /// Gesamtseitenzahl; nur bei mehrseitigen Plänen zu verwenden; bei einseitigem Plan muss es weggelassen werden
    let z: String?
    /// Sprache des Plans im Format ss-CC (nach BCP-47, http://tools.ietf.org/html/ bcp47), z. B. "de-DE", "de-CH", "en-US" etc. (KBV: nach RFC-3066 (ISO 631- 1/ISO 3166alpha-2))
    let l: String
    /// Bundle ID
    var bundleID: String?
    /// Composition ID
    var compositionID: String?
    /// Patient
    var P: PatientUKF
    /// Ausdruckender des Medikationsplans
    var A: AutorUKF
    /// Parameter, die 3 Druck-Parameterzeilen werden aus Geschlecht sowie den hier angegebenen optionalen Attributen sinnvoll in der Reihenfolge befüllt: Allerg./Unv.:, schwanger, stillend, Gew.:, Größe:, Krea.:, Geschl.:, Freitext. Nach jeweils max. 25 Zeichen pro Zeile muss ein Umbruch erfolgen. Wenn die 3 Zeilen für die Anzeige nicht ausreichen, endet die 3. Zeile mit "..."
    var O: ObservationUKF?
    /// Blöcke ggf. mit Überschrift (Gruppierungen von Medikationseinträgen)
    var S: [Section]?
}

