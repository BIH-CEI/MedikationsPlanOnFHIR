//
//  FormViewObservation.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 22.11.21.
//

import SwiftUI

struct FormViewObservation: View {
    @State var isActive = false
    var observation: ObservationUKF
    var patientID: String
    var issueDate: String
    var body: some View {
        Form {
            SwiftUI.Section(header: Text("Observations")) {
                HStack {
                    Text("Gewicht")
                    Spacer()
                    Text(observation.w != nil ? observation.w! + " kg" : "")
                }
                HStack {
                    Text("Größe")
                    Spacer()
                    Text(observation.h != nil ? observation.h! + " cm" : "")
                }
                HStack {
                    Text("Kreatinin")
                    Spacer()
                    Text(observation.h != nil ? observation.h! + "mg/dl." : "")
                }
                HStack {
                    Text("Schwanger")
                    Spacer()
                    Text(observation.p == "1" ? "Ja" : "Keine Angabe")
                }
                HStack {
                    Text("Stillend")
                    Spacer()
                    Text(observation.b == "1" ? "Ja" : "Keine Angabe")
                }
                HStack {
                    Text("Freitext")
                    Spacer()
                    Text(observation.x ?? "")
                }
            }
            SwiftUI.Section(header: Text("Allergien und Unverträglichkeiten")) {
                HStack {
                    Text("AI")
                    Spacer()
                    Text(observation.ai ?? "")
                }
            }
        }.toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("Observation")
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
                Text(Data(UKFUtility.observationToFHIR(observation: observation, patientID: patientID, issueDate: issueDate).debugDescription.utf8).prettyJson!)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct FormViewObservation_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormViewObservation(isActive: false, observation: dev.model.O!, patientID: dev.model.P.id!, issueDate: dev.model.A.t)
                .navigationBarTitle("", displayMode: .inline)
        }
    }
}
