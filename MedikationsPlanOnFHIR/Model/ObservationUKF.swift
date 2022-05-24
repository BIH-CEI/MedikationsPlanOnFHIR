//
//  ObservationUKF.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 06.09.21.
//

import Foundation

/*
 Element (Observation)
 Invariante INV-O-1: mindestens ein Attribut muss genannt sein, ansonsten muss das Element O weggelassen werden
 */
/// This is the struct for the observation in UKF format
struct ObservationUKF: Decodable, Hashable {
    /// Gewicht des Patienten in kg. Wenn nicht angegeben, muss das Attribut weggelassen werden.
    let w: String?
    var wId: String?
    /// Körpergröße des Patienten in cm. Wenn nicht angegeben, muss das Attribut weggelassen werden.
    let h: String?
    var hId: String?
    /// Kreatininwert des Patienten in mg/dl. Wenn nicht angegeben, muss das Attribut weggelassen werden.
    let c: String?
    var cId: String?
    /// Allergie(n) & Unverträglichkeiten des Patienten. Wenn nicht angegeben, muss das Attribut weggelassen werden.
    let ai: String?
    var aiID = [String]()
    /// Information darüber, ob die Patientin aktuell schwanger ist. Wenn zutreffend ist der Wert „1“ zu setzen. Wenn nicht zutreffend, muss das Attribut weggelassen werden. Dieser Zustand bedeutet, dass keine Aussage über den Zustand getroffen werden kann.
    let p: String?
    var pId: String?
    /// Information darüber, ob die Patientin aktuell stillend ist. Wenn zutreffend, ist der Wert „1“ zu setzen. Wenn nicht zutreffend, muss das Attribut weggelassen werden.
    let b: String?
    var bId: String?
    /// Freitext, um Parameter zu ergänzen. Wenn nicht angegeben muss, das Attribut weggelassen werden. Darf maximal 2 Umbrüche enthalten „~“. Zwischen Beginn und erstem Umbruch bzw. zwischen erstem Umbruch und zweitem Umbruch dürfen max. je 25 Zeichen enthalten sein. Das Verwenden des Tildezeichens „~“ ist bei der Eingabe des Freitextes nicht erlaubt (Kap. 7.3.5 Zeilenumbrüche).
    let x: String?
    
    /// Checks if the Observation object is empty
    func isEmpty() -> Bool {
        return w == nil && h == nil && c == nil && ai == nil && p == nil && b == nil && x == nil
    }
}
