//
//  FormViewPatient.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 21.11.21.
//

import SwiftUI

struct FormViewPatient: View {
    @State var isActive = false
    var patient: PatientUKF
    var body: some View {
        Form {
            SwiftUI.Section(header: Text("Name")) {
                HStack {
                    Text("Titel")
                    Spacer()
                    Text(patient.t ?? "")
                }
                HStack {
                    Text("Vorname")
                    Spacer()
                    Text(patient.g)
                }
                HStack {
                    Text("Nachname")
                    Spacer()
                    Text(patient.f)
                }
                HStack {
                    Text("Namenzusatz")
                    Spacer()
                    Text(patient.z ?? "")
                }
                HStack {
                    Text("Vorsatzwort")
                    Spacer()
                    Text(patient.v ?? "")
                }
            }
            SwiftUI.Section(header: Text("Elektronische Gesundheitskarte")) {
                HStack {
                    Text("Versicherten-ID")
                    Spacer()
                    Text(patient.egk ?? "")
                }
            }
            SwiftUI.Section(header: Text("Geschlecht")) {
                HStack {
                    Text("Geschlecht")
                    Spacer()
                    Text(patient.s == "D" ? "Divers" : patient.s == "W" ? "Weiblich" : patient.s == "M" ? "Männlich" : patient.s == "X" ? "Nicht definiert" : "")
                }
            }
            SwiftUI.Section(header: Text("Geburtsdatum")) {
                HStack {
                    Text("Datum")
                    Spacer()
                    Text(getFHIRDate(date: patient.b).description)
                }
            }
            SwiftUI.Section(header: Text("Identifikation")) {
                HStack {
                    Text("UUID")
                    Spacer()
                    Text(patient.id!)
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("Patient")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isActive.toggle()
                } label: {
                    Text("JSON")
                }
            }
        })
        .sheet(isPresented: $isActive) {
            ScrollView {
                Text(Data(UKFUtility.patientToFHIR(patient: patient).debugDescription.utf8).prettyJson!)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct FormViewPatient_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormViewPatient(isActive: false, patient: dev.model.P)
                .navigationBarTitle("", displayMode: .inline)
        }
    }
}
