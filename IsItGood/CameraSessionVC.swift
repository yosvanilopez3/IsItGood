//
//  CameraSessionVC.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/28/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//

import UIKit
import AVKit
import Vision

class CameraSessionVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up Camera Session
        let cameraSession = AVCaptureSession()
        cameraSession.sessionPreset = .hd1920x1080;
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        cameraSession.addInput(input);
        cameraSession.startRunning();
        
        // Show user the camera on the VC
        let preview = AVCaptureVideoPreviewLayer(session: cameraSession);
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        view.layer.addSublayer(preview);
        preview.frame = view.frame;
        
        let output = AVCaptureVideoDataOutput();
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"));
        cameraSession.addOutput(output);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }


}
