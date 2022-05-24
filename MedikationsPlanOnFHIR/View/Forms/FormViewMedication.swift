//
//  FormViewMedication.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 29.11.21.
//

import Foundation
import SwiftUI

struct FormViewMedication: View {
    @State var isActive = false
    @State var jsonText: String?
    var sections: [Section]
    var patientID: String
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(sections, id: \.self) { section in
                    SwiftUI.Section(header: MedicationSection(name: section.c != nil ? zwischenUeberschrift[section.c!]! :
                                                                    section.t != nil ? section.t! : " ")) {
                        MedicationCell(medications: section.M)
                    }
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("Medikation")
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
                Text(jsonText ?? "Loading...")
                    .fixedSize(horizontal: false, vertical: true)
            }.task {
                jsonText = await Data(UKFUtility.medicationStatementToFHIR(sections: sections, patientID: patientID).debugDescription.utf8).prettyJson!
            }
        }
    }
}

struct MedicationCell: View {
    var medications: [Medication]?
    var body: some View {
        if medications == nil {
            Text("EMPTY")
        } else {
            ForEach(medications!, id: \.id) { medication in
                VStack {
                    HStack {
                        Text(medication.a ?? "Empty")
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    HStack {
                        Text("Name")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    HStack {
                        Text(medication.p ?? "")
                        Spacer()
                    }.padding(.horizontal, 20)
                    HStack {
                        Text("PZN")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Spacer()
                    }.padding(.horizontal, 20)
                    HStack {
                        VStack {
                            Text("Morgens")
                            Text(medication.m?.replacingOccurrences(of: "bei Bedarf", with: " B") ?? "0")
                        }
                        Spacer()
                        VStack {
                            Text("Mittags")
                            Text(medication.d?.replacingOccurrences(of: "bei Bedarf", with: " B") ?? "0")
                        }
                        Spacer()
                        VStack {
                            Text("Abends")
                            Text(medication.v?.replacingOccurrences(of: "bei Bedarf", with: " B") ?? "0")
                        }
                        Spacer()
                        VStack {
                            Text("Zur Nacht")
                            Text(medication.h?.replacingOccurrences(of: "bei Bedarf", with: " B") ?? "0")
                        }
                    }.padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    if medication.t != nil {
                        HStack {
                            Text("Freitextdosierung:")
                                .bold()
                            Spacer()
                            Text(medication.t!)
                            Spacer()
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    }
                    if medication.du != nil {
                        HStack {
                            Text("Dosiereinheit:")
                                .bold()
                            Spacer()
                            Text(dosierEinheit[medication.du!] ?? "")
                            Spacer()
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    }
                    if medication.dud != nil {
                        HStack {
                            Text("Dosiereinheit:")
                                .bold()
                            Spacer()
                            Text(medication.dud!)
                            Spacer()
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    }
                    if medication.r != nil {
                        HStack {
                            Text("Grund der Behandlung:")
                                .bold()
                            Spacer()
                            Text(medication.r!)
                            Spacer()
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    }
                }.padding(5)
                Divider()
            }
        }
    }
}
                       
struct MedicationSection: View {
    var name: String
    var body: some View {
        Rectangle()
           .fill(Color.gray)
           .frame(maxWidth: .infinity)
           .frame(height: 55)
           .overlay(
                Text(name)
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .minimumScaleFactor(0.01)
                    .padding()
           )
    }
}

struct FormViewMedication_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormViewMedication(isActive: false, sections: dev.model.S!, patientID: dev.model.P.id!)
                .navigationBarTitle("", displayMode: .inline)
        }
    }
}
