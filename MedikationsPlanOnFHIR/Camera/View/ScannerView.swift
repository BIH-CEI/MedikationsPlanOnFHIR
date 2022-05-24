//
//  ScannerView.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 20.10.21.
//

import SwiftUI

struct QRView: View {
    
    @ObservedObject var viewModel: ScannerVM
    //         <A n="Dr. Fritz Überall" s="Hauptstraße 55" z="01234" c="Am Ort" lanr="1656304456" p="04562-12345" e="f.ueberall@mein-netz.de" t="2017-05-02T12:00:00"/>
    let inputMedikationsPlan = """
    <MP v="024" u="MPP" U="56DEC1A02F9340A1BA73704ABEF8B704" l="de-DE">
        <P t="Prof. Dr." g="Jürgen Test" z="Graf" v="von und zu" f="Wernersen" b="19400324" egk="A123456789" s="M"/>
        <A n="Krankenhaus" kik="1656304456" t="2017-05-02T12:00:00"/>
        <O w="89" c="1.3" p="1" h="177" b="1"/>
        <S c="411">
            <M p="4877970" m="2 bei Bedarf" t="max. 3" du="5" i="akut" r="Herzschmerzen"/>
            <M p="2083906" h="1" du="1" i="bei Bedarf" r="Schlaflosigkeit"/>
        </S>
        <S c="415">
            <M p="4877970" m="2 bei Bedarf" t="max. 3" du="5" i="akut" r="Herzschmerzen"/>
            <M p="2223945" h="1" dud="Test" i="bei Bedarf" r="Schlaflosigkeit"/>
        </S>
    </MP>
    """
    
    let bmpPlan1 = """
    <MP v="024" U="02BD2867FB024401A590D59D94E1FFAE" l="de-DE">
        <P g="Jürgen" f="Wernersen" b="19400324"/>
        <A n="Praxis Dr. Michael Müller" s="Schloßstr. 22" z="10555" c="Berlin" p="030-1234567" e="dr.mueller@kbv-net.de" t="2017-05-02T12:00:00"/>
        <O/>
        <S>
            <M p="230272" m="1" du="1" r="Herz/Blutdruck"/>
            <M p="2223945" m="1" du="1" r="Blutdruck"/>
            <M p="558736" m="20" v="20" du="p" i="Wechseln der Injektionsstellen, unmittelbar vor einer Mahlzeit spritzen" r="Diabetes"/>
            <M p="9900751" v="1" du="1" r="Blutfette"/>
        </S>
        <S t="zu besonderen Zeiten anzuwendende Medikamente">
            <M p="2239828" t="alle drei Tage 1" du="1" i="auf wechselnde Stellen aufkleben" r="Schmerzen"/>
        </S>
        <S c="418">
            <M p="2455874" m="1" du="1" r="Stimmung"/>
        </S>
    </MP>
    """
    
    let bmpPlan2 = """
    <MP v="024" U="4001B2C2231B4E32AF1A24DE10C31E03" l="de-DE">
        <P g="Ricarda" f="Musterfrau" b="19470425"/>
        <A n="Praxis Dr. Michael Müller" s="Schloßstr. 22" z="10555" c="Berlin" p="030-1234567" e="dr.mueller@kbv-net.de" t="2017-05-02T12:00:00"/>
        <O ai="Laktose"/>
        <S>
            <M f="TAB" m="1" v="1" du="1" r="Diabetes">
                <W w="Metformin" s="500 mg"/>
            </M>
            <M f="TAB" m="1" du="1" r="Blutdruck">
                <W w="Lisinopril" s="5 mg"/>
            </M>
        </S>
        <S t="Antibiotikatherapie für 7 Tage (31.5. bis 6.6.)">
            <M p="2394397" m="1" d="1" v="1" du="1" r="Bronchitis"/>
        </S>
        <S t="Neurologische Medikation (Dr. A. Schneider)">
            <M p="11186232" t="siehe nächste Zeile" i="Feste Einnahmezeiten beachten!" r="Parkinson" x="Einnahmezeiten Parkinsonmedikation: 8:30 = 1 Tabl.; 12:30 = 2 Tabl.; 16:00 = 1 Tabl.; 18:30 = 1 Tabl."/>
        </S>
    </MP>
    """

    let bmpPlan3 = """
    <MP v="024" U="E83F2A1E65AE4631AFA8993118E46EA6" l="de-DE">
        <P g="Anton" f="Beispiel" b="19400101"/>
        <A n="Beispiel-Apotheke" s="Musterweg 1" z="01662" c="Meißen" p="03521-1234567" e="info@beispiel-apotheke.de" t="2017-05-02T12:00:00"/>
        <O/>
        <S>
            <M p="536338" m="10" d="6" v="8" du="p" i="vor den Mahlzeiten, nach Messergebnis" r="Diabetes mellitus"/>
            <M p="5387825" t="Siehe Hinweis" du="p" i="Abends 18-30 I.E. nach Messergebnis" r="Diabetes mellitus"/>
            <M p="8839133" m="1" v="1" du="1" i="zu oder unmittelbar nach den Mahlzeiten" r="Diabetes mellitus"/>
            <M p="811744" m="1/2" v="1" du="1" i="30 min vor dem Frühstück" r="Schilddrüsenunterfunktion"/>
            <M p="1562556" m="1" du="1" r="Wassereinlagerung Beine"/>
            <M p="1755717" m="1" du="1" i="ggf. bei weiter niedrigem Blutdruck früh nur 0,5" r="Bluthochdruck"/>
            <M p="1014949" m="1" du="1" r="Bluthochdruck"/>
        </S>
        <S c="411">
            <M p="8533670" t="bei Bedarf 1 Tabl" du="1" i="nur im Bedarfsfall" r="Schmerzen"/>
            <M p="4443361" m="30" d="30" v="30" du="6" i="nur im Bedarfsfall" r="Schmerzen"/>
        </S>
    </MP>
    """
    
    let bmpPlan4 = """
    <MP v="024" U="EA620D79D334428CBA6203181EAA1379" l="de-DE">
        <P g="Ivan" f="Ivanov" b="19580213" t="Prof. Dr."/>
        <A n="Beispiel-Apotheke" s="Musterweg 1" z="01662" c="Meißen" p="03521-1234567" e="info@beispiel-apotheke.de" t="2017-05-02T12:00:00"/>
        <O/>
        <S>
            <M p="5701380" m="1" du="1" r="Schilddrüse"/>
            <M p="1016440" m="1" du="1" r="Bluthochdruck"/>
            <M p="602905" m="1" du="1" r="Magenbeschwerden"/>
        </S>
        <S c="418">
            <M p="2246627" t="siehe Hinweistext" du="1" i="bei Bedarf 1 Tablette, bevorzugt abends" r="Heuschnupfen"/>
            <M p="3436979" m="1" v="1" du="o" i="bei Bedarf (Pollenflug) morgens und abends je 1 Sprühstoß pro Nasenloch" r="Heuschnupfen"/>
            <M p="4512286" t="siehe Hinweistext" i="Behandl. fortsetzen; mind. 2x/Woche auf erkrankten Nagel auftragen" r="Nagelpilz"/>
            <R t="Pflegecreme (Basiscreme DAC, Nachtkerzenöl 10%)  -- täglich auf die betroffenen Stellen --"/>
        </S>
    </MP>
    """

    let bmpPlan5 = """
    <MP v="024" U="57D5FC3D08E14676875564CFD6412399" a="1" z="2" l="de-DE">
        <P g="Rudolf" f="Testmann" b="19591019"/>
        <A kik="123456789" n="Dr. Neuron, Krankenhaus XYZ" s="Schloßstr. 22" z="10555" c="Berlin" p="030-1234567" e="dr.neuron@KH-XYZ.de" t="2017-05-02T12:00:00"/>
        <O/>
        <S c="412">
            <M p="2223945" m="1" du="1" r="Blutdruck"/>
            <M p="4634724" m="1" du="1" r="Blutdruck"/>
            <M p="6718649" m="1" du="1" r="Blutverdünner"/>
            <M p="9533264" v="1" du="1" r="Blutfette"/>
            <M p="1725082" m="1" d="1" v="1" du="1" i="nach den Mahlzeiten einnehmen" r="Zucker"/>
            <M p="7052750" h="1" du="1" r="Schlafen"/>
            <M p="6564270" v="1" du="1" r="Gicht"/>
            <M p="2754677" m="1" du="1" r="Schilddrüse"/>
        </S>
        <S c="411">
            <M p="1418931" m="10" d="10" du="s" r="Verstopfung"/>
            <M p="3909372" h="1/2" du="1" i="nur bei Schlaflosigkeit ab 22:00 Uhr" r="Schlaflosigkeit"/>
        </S>
        <S c="421">
            <X t="tägliche Blutdruckmessung; Blutzuckermessungen 3mal täglich, solange Cortison eingenommen wird (siehe nächste Seite)"/>
            <X t="Lähmung Gesichtsnerv: 3mal täglich Bewegungsübungen Gesicht laut Anleitung vor dem Spiegel; nachts Augenklappe und Augensalbe"/>
        </S>
        <S t="Behandlung Gesichtslähmung 13.5. bis einsch. 17.5.">
            <M p="1484543" m="3" du="1" i="5 Tage lang gleiche Dosierung einnehmen!" r="Gesichtslähmung"/>
        </S>
        <S t="Behandlung Gesichtslähmung am 18.5.">
            <M p="1484543" m="2,5" du="1" i="Erster Tag Dosisreduzierung" r="Gesichtslähmung"/>
        </S>
        <S t="Behandlung Gesichtslähmung am 19.5.">
            <M p="1484543" m="2" du="1" r="Gesichtslähmung"/>
        </S>
        <S t="Behandlung Gesichtslähmung am 20.5.">
            <M p="1484543" m="1,5" du="1" r="Gesichtslähmung"/>
        </S>
        <S t="Behandlung Gesichtslähmung am 21.5.">
            <M p="1484543" m="1" du="1" r="Gesichtslähmung"/>
        </S>
        <S t="Behandlung Gesichtslähmung am 22.5.">
            <M p="1484543" m="1/2" du="1" i="letzer Tag - danach Prednisolon nicht mehr einnehmen" r="Gesichtslähmung"/>
        </S>
        <S t="zusätzliche Maßnahmen">
            <X t="nachts ca. 1 cm Dexpanthenol-Augensalbe in rechtes Auge und mit Uhrglas-Augenverband abkleben"/>
            <X t="täglich mehrmals künstliche Tränen in rechtes Auge träufeln"/>
        </S>
    </MP>

    """

    var body: some View {
        // ZStack to overlap the information
        ZStack {
            // The Scanner
            QrCodeScannerView()
                .found(r: self.viewModel.onFoundQrCode)
                .torchLight(isOn: self.viewModel.torchIsOn)
                .interval(delay: self.viewModel.scanInterval)
                .simulator(mockBarCode: self.inputMedikationsPlan)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("Scanner")
                        .font(.subheadline)
                    Text(self.viewModel.lastQrCode)
                        .bold()
                        .lineLimit(5)
                        .padding()
                }
                .padding(.vertical, 20)
                Spacer()
                HStack {
                    Button(action: {
                        self.viewModel.torchIsOn.toggle()
                    }, label: {
                        Image(systemName: self.viewModel.torchIsOn ? "flashlight.on.fill" : "flashlight.off.fill")
                            .imageScale(.large)
                            .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color.blue)
                            .padding()
                    })
                }
                .frame(width: 60, height: 60)
                .background(ZStack {
                    Circle()
                        .fill(Color.white)
                })
//                .cornerRadius(50)
            }.padding()
//            Rectangle()
//                .stroke(Color.yellow, style: StrokeStyle(lineWidth: 5.0,lineCap: .round, lineJoin: .bevel, dash: [60, 215], dashPhase: 29))
//                .frame(width: 275, height: 275)
        }
    }
}


struct QRView_Previews: PreviewProvider {
    @StateObject static var scannerVM = ScannerVM()
    static var previews: some View {
        QRView(viewModel: scannerVM)
    }
}
