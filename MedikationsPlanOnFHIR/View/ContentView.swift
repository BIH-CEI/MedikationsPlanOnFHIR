//
//  ContentView.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 31.08.21.
//

import SwiftUI

struct IfElseView: View {
    @StateObject var ecgVM = MPVM.shared
    @ViewBuilder
    var body: some View {
        if ecgVM.medikationsPlanArr.isEmpty {
            WelcomeScreen()
        } else {
            MedikationsPlan(ecgVM: ecgVM)
        }
    }
}

struct ContentView: View {
    @StateObject private var scannerVM = ScannerVM()
    @StateObject var ecgVM = MPVM.shared
        
    var body: some View {
        NavigationView {
            IfElseView()
            .sheet(isPresented: $scannerVM.scanning) {
                QRView(viewModel: scannerVM)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Medikationspläne")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        SMARTClient.shared.smart.reset()
                    } label: {
                        Image(systemName: "xmark.icloud")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            do {
                                let authStatus = try await SMARTClient.shared.auth()

                                if authStatus {
                                    DispatchQueue.main.async {
                                        scannerVM.startScanning()
                                    }
                                }
                            } catch {
                                SMARTClient.shared.smart.reset()
                                let authStatus = try await SMARTClient.shared.auth()

                                if authStatus {
                                    DispatchQueue.main.async {
                                        scannerVM.startScanning()
                                    }
                                }
                            }
                        }
                        
                        // Testing
//                            DeveloperPreview()
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                }
            }
            .alert(isPresented: $ecgVM.errorBool) {
                Alert(title: Text("Error"),
                      message: Text(ecgVM.errorMessage),
                      dismissButton: .default(Text("OK"), action: {
                            ecgVM.errorMessage = ""

                            })
                )
            }
        }
        .navigationViewStyle(.stack)
        .overlay {
            LoadingView()
        }
    }
}

struct WelcomeScreen: View {
    var body: some View {
        VStack {
            HStack {
                Text("Medikationsplan mit")
                Image(systemName: "qrcode.viewfinder")
                Text("scannen")
            }
        }
    }
}

struct MedikationsPlanCell: View {
    @Binding var value: MedikationsPlanUKF
    var body: some View {
        VStack {
            HStack {
                Text("Medikationsplan")
                    .font(.title)
                Spacer()
            }
            HStack {
                Text("Patient: \(value.P.g) \(value.P.f)")
                Spacer()
                Button {
                    Task {
                        await UKFUtility.uploadMedikationsplan(medikationsPlanUKF: value)
                    }
//                  UKFUtility.buildTransactionBundle(medikationsPlanUKF: value)
//                    Task {
//                        await UKFUtility.buildDocumentBundle(medikationsPlanUKF: value)
//                    }
                } label: {
                    Image(systemName: "icloud.and.arrow.up")
                }
            }
            HStack {
                Text("Datum: \(value.A.t)")
                Spacer()
            }
        }
    }
}

struct MedikationsPlan: View {
    @ObservedObject var ecgVM: MPVM
    @State var isActive = false
    @State var clickedItem: String?
    var body: some View {
        List {
            ForEach($ecgVM.medikationsPlanArr, id: \.self) { $value in
                VStack {
                    MedikationsPlanCell(value: $value)
                    NavigationLink(isActive: $isActive) {
                        if clickedItem == "P" {
                            FormViewPatient(patient: value.P)
                        } else if clickedItem == "A" {
                            FormViewAutor(autor: value.A)
                        } else if let observation = value.O, clickedItem == "O" {
                            FormViewObservation(observation: observation, patientID: value.P.id!, issueDate: value.A.t)
                        } else if clickedItem == "S" {
                            FormViewMedication(sections: value.S!, patientID: value.P.id!)
                        }
                    } label: {
                        EmptyView()
                    }.hidden()
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button("Patient") {
                        isActive = true
                        clickedItem = "P"
                    }
                    .tint(.blue)
                    .buttonStyle(DefaultButtonStyle())
                    Button("Autor") {
                        isActive = true
                        clickedItem = "A"
                    }
                    .tint(.yellow)
                    .buttonStyle(DefaultButtonStyle())
                    Button("Observation") {
                        isActive = true
                        clickedItem = "O"
                    }
                    .tint(.purple)
                    .disabled(value.O != nil ? value.O!.isEmpty() ? true : false : true)
                    .buttonStyle(DefaultButtonStyle())
                    Button("Medikation") {
                        isActive = true
                        clickedItem = "S"
                    }
                    .tint(.green)
                    .disabled(value.S != nil ? false : true)
                    .buttonStyle(DefaultButtonStyle())
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        if let index = ecgVM.medikationsPlanArr.firstIndex(of: value) {
                            ecgVM.medikationsPlanArr.remove(at: index)
                        }
                    } label: {
                        Label("Löschen", systemImage: "trash")
                    }
                }
            }
        }.buttonStyle(BorderlessButtonStyle())
    }
}

struct noWiFiView: View {
    var body: some View {
        ZStack {
            Color(.systemBlue).ignoresSafeArea()
            VStack {
                Image(systemName: "wifi.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.white)
                Text("WiFi nicht vefügbar")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

struct LoadingView: View {
    @StateObject var ecgVM = MPVM.shared
    var body: some View {
        if ecgVM.fetching {
            ZStack {
                Color(white: 0, opacity: 0.5)
                ProgressView().tint(.white)
            }.ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(ecgVM: dev.mpvm)
    }
}
