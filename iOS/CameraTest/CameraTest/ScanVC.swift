//
//  ScanVC.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/11/29.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ScanVC: UIViewController, AVCapturePhotoCaptureDelegate
{
    // Capture Session Variables
    @IBOutlet weak var preView: UIView!
    var captureS = AVCaptureSession()
    var stillImageOutput = AVCapturePhotoOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    // Process Visualizer Variables
    @IBOutlet weak var ProcessIndi: UIActivityIndicatorView!
    @IBOutlet weak var ProcessLabel: UILabel!
    
    // Current Time Variable
    var play_name_date = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Beginning Speak
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "스캔 화면입니다. 스캔하려면 화면을 두번 누르세요.")
        
        // MARK: - Init Capture Session
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
        
        // Init Recognizer
        let DoublePress = UITapGestureRecognizer(target: self, action: #selector(TakePic))
        DoublePress.numberOfTapsRequired = 2
        preView.addGestureRecognizer(DoublePress)
            
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        // Stop Capture Session When Exit
        super.viewWillDisappear(animated)
        self.captureS.stopRunning()
        
        // Stop Speaking When Exit
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "메인으로 이동합니다.")
    }
    
    // MARK: - Setup Capture Session
    func setupLivePreview()
    {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureS)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        preView.layer.addSublayer(videoPreviewLayer)
    }
    
    @objc func TakePic()
    {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute:
            {
                // Notify Currently Processing
                AudioData.super_synt.stopSpeaking(at: .word)
                AudioData.SuperSpeak(str: "사진을 처리하는 중입니다.")
            })
        // MARK: - Prepare Image to Send
        guard let imageData = photo.fileDataRepresentation()
            else {return}
        
        // Convert image to Base64
        let image = UIImage(data: imageData)
        let data = image?.pngData()
        let b64_d = data?.base64EncodedString()
        
        // Get Current Date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        
        // Setup Voice Gender
        var voicegender = String()
        if UserDefaults.standard.value(forKey: "VoiceGender") == nil
        {
            UserDefaults.standard.set(0, forKey: "VoiceGender")
        }
        
        switch UserDefaults.standard.value(forKey: "VoiceGender") as! Int
        {
        case 0:
            voicegender = "M"
        case 1:
            voicegender = "W"
        case 2:
            voicegender = "N"
        default:
            voicegender = "M"
        }
        
        // Animate Process Visualizer
        ProcessIndi.startAnimating()
        ProcessLabel.text = "Processing..."
        
        // Hide Camera View
        preView.alpha = 0
        
        // MARK: - POST image to Server
        AF.request("http://35.221.78.179:5000/base64img", method: .post, parameters: ["image" : b64_d, "date" : formatter.string(from: date), "gender" : voicegender], encoder: JSONParameterEncoder.default).responseJSON
        { response in  switch response.result
            {
            case .failure(let error):
                print(error)
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {print(responseString)}
            case .success(let responseObject):
                
                // Recieve Data
                let dicdata = responseObject as! Dictionary<String, Any>
                let stringaudio = dicdata["audio"] as! String
                self.play_name_date = dicdata["date"] as! String
                let summary = dicdata["summary"] as! String
            
                // Save Data
                AudioData.AddNameData(name: self.play_name_date)
                AudioData.AddAudioData(name: self.play_name_date, audio_b64: stringaudio, needcorrect: true)
                AudioData.AddSummaryData(nameofdate: self.play_name_date, summary: summary)
    
                UserDefaults.standard.set(self.play_name_date, forKey: "DefaultAudio")
                UserDefaults.standard.set(self.play_name_date, forKey: "DefaultSummary")
                
                // Notify Image Process Completed
                AudioData.SuperSpeak(str: "사진이 처리되어 메인으로 이동합니다.")
                
                // Move Back To Main VC
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {self.navigationController?.popToRootViewController(animated: true)})
            }
        }
    }
}
