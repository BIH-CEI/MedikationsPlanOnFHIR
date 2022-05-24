//
//  CameraPreview.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 21.10.21.
//

import UIKit
import AVFoundation


class CameraPreview: UIView {
    
    private var label: UILabel?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var session = AVCaptureSession()
    weak var delegate: QrCodeCameraDelegate?
    
    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        self.session = session
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// The simulator view to  simulate the data
    func createSimulatorView(delegate: QrCodeCameraDelegate){
        self.delegate = delegate
        self.backgroundColor = UIColor.black
        label = UILabel(frame: self.bounds)
        label?.numberOfLines = 4
        label?.text = "Click here to simulate scan"
        label?.textColor = UIColor.white
        label?.textAlignment = .center
        if let label = label {
            addSubview(label)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(gesture)
    }
    
    /// Function to catch the click on the simulators screen
    @objc func onClick(){
        print("CameraPreview: onClick()")
        delegate?.onSimulateScanning()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        #if targetEnvironment(simulator)
            print("CameraPreview: layoutSubviews() - Pass the label bounds")
            label?.frame = self.bounds
        #else
            print("CameraPreview: layoutSubviews() - Pass the previewLayer bounds")
            previewLayer?.frame = self.bounds
        #endif
    }
}
