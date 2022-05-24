//
//  UKFUtility+Autor.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 23.03.22.
//

import Foundation
import FHIR

extension UKFUtility {
    // MARK: - Autor (A)
    static func autorToFHIR(autor: AutorUKF) -> Resource {
        if autor.lanr != nil {
            // Practitioner FHIR
            let practitionerFHIR = Practitioner()
            let humanName = HumanName()
            let address = Address()
            var contactPoints = [ContactPoint]()
            var identifier = [Identifier]()
            
            // id
            practitionerFHIR.id = FHIRString(autor.id!)
            
            // Meta
            let practitionerMeta = Meta()
            practitionerMeta.profile = [FHIRCanonical("https://www.charite.de/fhir/medikationsplan/StructureDefinition/Practitioner")!]
            
            // n Value
            humanName.text = FHIRString(autor.n)
            
            // s Value
            if autor.s != nil {
                address.line = [FHIRString(autor.s!)]
                address.text = address.line![0]
            }
            
            // z Value
            if autor.z != nil {
                address.postalCode = FHIRString(autor.z!)
                if autor.s != nil {
                    address.text = FHIRString("\(address.text!.string), \(autor.z!)")
                }
            }
            
            // o Value
            if autor.c != nil {
                address.city = FHIRString(autor.c!)
                
                address.text = FHIRString("\(address.text ?? "") \(autor.c!)")
            }
            
            // p Value
            if autor.p != nil {
                let contactPoint = ContactPoint()
                contactPoint.system = ContactPointSystem.phone
                contactPoint.value = FHIRString(autor.p!)
                contactPoints.append(contactPoint)
            }
            
            // e Value
            if autor.e != nil {
                let contactPoint = ContactPoint()
                contactPoint.system = ContactPointSystem.email
                contactPoint.value = FHIRString(autor.e!)
                contactPoints.append(contactPoint)
            }
            
            // lanr Value
            let identifierCoding = Coding()
            identifierCoding.code = "LANR"
            identifierCoding.system = FHIRURL("http://terminology.hl7.org/CodeSystem/v2-0203")
            
            let identifierCodeableConcept = CodeableConcept()
            identifierCodeableConcept.coding = [identifierCoding]
            
            let identifierLarn = Identifier()
            identifierLarn.use = .official
            identifierLarn.type = identifierCodeableConcept
            identifierLarn.system = FHIRURL("https://fhir.kbv.de/NamingSystem/KBV_NS_Base_ANR")
            identifierLarn.value = FHIRString(autor.lanr!)
            identifier.append(identifierLarn)
                        
            // Decorate the practitioner
            practitionerFHIR.name = [humanName]
            practitionerFHIR.meta = practitionerMeta
            if autor.s != nil || autor.z != nil || autor.c != nil {
                practitionerFHIR.address = [address]
            }
            if autor.p != nil || autor.e != nil {
                practitionerFHIR.telecom = contactPoints
            }
            practitionerFHIR.identifier = identifier
            return practitionerFHIR
        }
        // kik Value
        else if autor.kik != nil {
            // Organization FHIR
            let organizationFHIR = Organization()
            // Identifier
            let identifier = Identifier()
            identifier.use = .official
            identifier.system = FHIRURL("http://fhir.de/sid/arge-ik/iknr")
            identifier.value = FHIRString(autor.kik!)
            let identifierCodeableConcept = CodeableConcept()
            let identifierCoding = Coding()
            identifierCoding.system = FHIRURL("http://terminology.hl7.org/CodeSystem/v2-0203")
            identifierCoding.code = "XX"
            identifierCodeableConcept.coding = [identifierCoding]
            identifier.type = identifierCodeableConcept
            // Decorate the resource
            organizationFHIR.identifier = [identifier]
            organizationFHIR.name = FHIRString(autor.n)
            return organizationFHIR
        }
        // idf Value
        else {
            // Organization FHIR
            let organizationFHIR = Organization()
            // Identifier
            let identifier = Identifier()
            identifier.use = .official
            identifier.system = FHIRURL("http://fhir.de/sid/bfarm/btmnr")
            identifier.value = FHIRString(autor.idf!)
            let identifierCodeableConcept = CodeableConcept()
            let identifierCoding = Coding()
            identifierCoding.system = FHIRURL("http://terminology.hl7.org/CodeSystem/v2-0203")
            identifierCoding.code = "RI"
            identifierCodeableConcept.coding = [identifierCoding]
            identifier.type = identifierCodeableConcept
            // Decorate the resource
            organizationFHIR.identifier = [identifier]
            organizationFHIR.name = FHIRString(autor.n)
            return organizationFHIR
        }
    }    
}
