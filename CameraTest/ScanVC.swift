//
//  ScanVC.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/11/29.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit
import AVFoundation

class ScanVC: UIViewController, AVCapturePhotoCaptureDelegate
{

    @IBOutlet weak var preView: UIView!
    
    var captureS = AVCaptureSession()
    var stillImageOutput = AVCapturePhotoOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        captureS.sessionPreset = .high
        guard let backCamera = AVCaptureDevice.default(for: .video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do
        {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureS.addInput(input)
            captureS.addOutput(stillImageOutput)
            setupLivePreview()
        }
        catch
        {
            print("Error Unable to initialize back camera")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureS.startRunning()
        }
        
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.preView.bounds
        }
        
        let DoublePress = UITapGestureRecognizer(target: self, action: #selector(TakePic))
        DoublePress.numberOfTapsRequired = 2
        preView.addGestureRecognizer(DoublePress)
            
    }
    
    func setupLivePreview()
    {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureS)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        preView.layer.addSublayer(videoPreviewLayer)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
    {
        guard let imageData = photo.fileDataRepresentation()
            else {return}
        
        let image = UIImage(data: imageData)
        
        print("Captured!!")
    }
    
    @objc func TakePic()
    {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        
        print("Pressed!!")
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.captureS.stopRunning()
    }

}
