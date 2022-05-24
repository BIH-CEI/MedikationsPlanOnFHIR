//
//  MedicationUKF.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 23.10.21.
//

import Foundation

/// This is the struct or the Section (List resource) in UKF format
struct Section: Decodable, Hashable {
    var id: String?
    /// Eine vom Anwender frei definierte Zwischenüberschrift. Darf nicht gleichzeitig mit MP.S.c angegeben werden.
    let t: String?
    /// Standardzwischenüberschrift zur Kategorisierung der Medikationen auf dem Plan. Vgl. Anhang 2, Tabelle 6: Schlüsselworte für Zwischenüberschriften. Darf nicht gleichzeitig mit MP.S.t (=Freitextzwischenüberschrift ) angegeben werden.
    let c: String?
    /// TODO Schauen ob Optional
    var M: [Medication]?
    
    func matches(section: Section) -> Bool {
        return t == section.t && c == section.c
    }
}

/// This is the struct for the medication in UKF format
struct Medication: Decodable, Hashable {
    var id: UUID?
    /// Pharmazentralnummer einer Fertigarzneimittelpackung. PZNs werden als Ganzzahl (Bereich 1.. 99999999) ohne führende Nullen übertragen. Zur Darstellung und Verarbeitung werden ggf. führende Nullen ergänzt und angezeigt (8-stellige PZN).
    let p: String?
    /// Bezeichnung (Handelsname) eines Arzneimittels, ggf. eines (Medizin-)Produktes oder Präparates nach Anhang 1. Der Handelsname kann definiert oder fehlend sein (wenn fehlend, ggf. bei Ausdruck aus der PZN ableiten).
    var a: String?
    /// Bezeichnung einer Darreichungsform in Form des IFA-Codes. Die Darreichungsform kann definiert oder fehlend sein (wenn fehlend, ggf. bei Ausdruck aus der PZN ableiten). Darf nicht gleichzeitig mit MP.S.M.fd (=Freitextdarreichungsform) angegeben werden.
    let f: String?
    /// Bezeichnung einer Darreichungsform in patientenverständlicher Kurzschreibweise. Die Darreichungsform kann definiert oder fehlend sein (wenn fehlend, ggf. bei Ausdruck aus der PZN ableiten). Darf nicht gleichzeitig mit MP.S.M.f (=IFA-Code) angegeben werden.
    let fd: String?
    
    /// Stellt die Einnahmedosis des Patienten am Morgen dar. Wenn Attribut fehlt, „0“ im Ausdruck. Darf nicht gleichzeitig mit MP.S.M.t (=Freitextdosierung) angegeben werden.
    let m: String?
    /// Stellt die Einnahmedosis des Patienten am Mittag dar. Wenn Attribut fehlt, „0“ im Ausdruck. Darf nicht gleichzeitig mit MP.S.M.t (=Freitextdosierung) angegeben werden.
    let d: String?
    /// Stellt die Einnahmedosis des Patienten am Abend dar. Wenn Attribut fehlt, „0“ im Ausdruck. Darf nicht gleichzeitig mit MP.S.M.t (=Freitextdosierung) angegeben werden.
    let v: String?
    /// Stellt die Einnahmedosis des Patienten zur Nacht dar. Wenn Attribut fehlt, „0“ im Ausdruck. Darf nicht gleichzeitig mit MP.S.M.t (=Freitextdosierung) angegeben werden.
    let h: String?
    /// Stellt die Freitextdosierung des Patienten dar. Darf nicht gleichzeitig mit MP.S.M.m (=Morgens), MP.S.M.d (=Mittags), MP.S.M.v (=Abends) oder MP.S.M.h (=zur Nacht) angegeben werden.
    let t: String?
    
    /// Bezeichnung einer Dosiereinheit, kodiert lt. Anhang 4. Darf nicht gleichzeitig mit MP.S.M.dud (=Freitextdosiereinheit) angegeben werden.
    let du: String?
    /// Freitextdosiereinheit Darf nicht gleichzeitig mit MP.S.M.du (=Dosiereinheit nach Anhang 4) angegeben werden.
    let dud: String?
    
    /// Relevante Hinweise zum Arzneimittel (z. B. Anwendung, Einnahme, Lagerung etc.). Darf max. einen manuellen Umbruch enthalten: "~"
    let i: String?
    /// Grund der Behandlung in patientenverständlicher Form. Darf max. einen manuellen Umbruch enthalten: "~"
    let r: String?
    /// Allgemeine Hinweise, die sich auf den vorhergehenden Medikationseintrag beziehen. Der Medikationseintrag und die gebundene Zusatzzeile sind untrennbar aneinandergeknüpft. Darf maximal 1 Umbruch enthalten „~“. Das Verwenden des Tildezeichens „~“ ist bei der Eingabe des Freitextes durch den Endanwender nicht erlaubt.
    let x: String?
    
    // Weglassen
    let W: Wirkstoff?
}

struct Wirkstoff: Decodable, Hashable {
    /// Bezeichnung eines oder mehrerer Wirkstoffe. Der Wirkstoffname kann definiert oder fehlend sein (wenn fehlend, ggf. bei Ausdruck aus der PZN ableiten). Die Regeln aus 7.3.7 sind anzuwenden.
    let w: String
    /// Angabe der Wirkstärke und der Wirkstärkeneinheit des jeweils zugehörigen Wirkstoffes/der jeweils zugehörigen Wirkstoffe. Die Wirkstärke kann definiert oder fehlend sein (wenn fehlend, ggf. bei Ausdruck aus der PZN ableiten).
    let s: String?
}

struct Rezeptur: Decodable, Hashable {
    /// Eintrag zu einer Rezeptur als Freitext. Darf maximal 1 Umbruch enthalten „~“. Das Verwenden des Tildezeichens „~“ ist bei der Eingabe des Freitextes nicht erlaubt. (Kap. 7.3.5 Zeilenumbrüche)
    let t: String
    /// Allgemeine Hinweise, die sich auf den vorhergehenden Rezeptureintrag beziehen. Der Rezeptureintrag und die gebundene Zusatzzeile sind untrennbar aneinandergeknüpft. Darf maximal 1 Umbruch enthalten „~“. Das Verwenden des Tildezeichens „~“ ist bei der Eingabe des Freitextes durch den Endanwender nicht erlaubt.
    let x: String?
}

struct Freitextzeile: Decodable, Hashable {
    /// Allgemeine Hinweise, die nicht einzelnen Medikationseinträgen zugewiesen sind.
    let t: String
}
