//
//  FormViewAutor.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 21.11.21.
//

import SwiftUI

struct FormViewAutor: View {
    @State var isActive = false
    var autor: AutorUKF
    var body: some View {
        Form {
            SwiftUI.Section(header: Text("Institution")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(autor.n)
                }
                HStack {
                    Text("Straße")
                    Spacer()
                    Text(autor.s ?? "")
                }
                HStack {
                    Text("PLZ")
                    Spacer()
                    Text(autor.z ?? "")
                }
                HStack {
                    Text("Ort")
                    Spacer()
                    Text(autor.c ?? "")
                }
            }
            SwiftUI.Section(header: Text("Kontaktdaten")) {
                HStack {
                    Text("Telefonnummer")
                    Spacer()
                    Text(autor.p ?? "")
                }
                HStack {
                    Text("E-Mail")
                    Spacer()
                    Text(autor.e ?? "")
                }
            }
            SwiftUI.Section(header: Text("Identifikation")) {
                HStack {
                    Text("Lebenslange Arztnummer")
                    Spacer()
                    Text(autor.lanr ?? "")
                }
                HStack {
                    Text("Apothekenidentifikationsnummer")
                    Spacer()
                    Text(autor.idf ?? "")
                }
                HStack {
                    Text("Krankenhausinstitutskennzeichen")
                    Spacer()
                    Text(autor.kik ?? "")
                }
                HStack {
                    Text("Datum")
                    Spacer()
                    Text(autor.t)
                }
                HStack {
                    Text("UUID")
                    Spacer()
                    Text(autor.id!)
                }
            }
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("Autor")
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
                Text(Data(UKFUtility.autorToFHIR(autor: autor).debugDescription.utf8).prettyJson!)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct FormViewAutor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormViewAutor(isActive: false, autor: dev.model.A)
                .navigationBarTitle("", displayMode: .inline)
        }
    }
}
