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

    @IBOutlet weak var preView: UIView!
    @IBOutlet weak var ProcessIndi: UIActivityIndicatorView!
    @IBOutlet weak var ProcessLabel: UILabel!
    
    var captureS = AVCaptureSession()
    var stillImageOutput = AVCapturePhotoOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    var play_name_date = String ()
    
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
        
        let data = image?.pngData()
        let b64_d = data?.base64EncodedString()
        
        let date = Date()
        let formatter = DateFormatter()
        
        var voicegender = "M"
        switch UserDefaults.standard.value(forKey: "VoiceGender") as! Int
        {
        case 0:
            voicegender = "M"
        case 1:
            voicegender = "F"
        case 2:
            voicegender = "N"
        default:
            voicegender = "M"
        }

        formatter.dateFormat = "yyyyMMddHHmm"
        
        ProcessIndi.startAnimating()
        ProcessLabel.text = "Processing..."
        
        preView.alpha = 0
        
        AF.request("http://35.221.78.179:5000/base64img", method: .post, parameters: ["image" : b64_d, "date" : formatter.string(from: date), "gender" : voicegender], encoder: JSONParameterEncoder.default).responseJSON
        { response in  switch response.result
            {
            case .failure(let error):
                print(error)
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {print(responseString)}
            case .success(let responseObject):
                let dicdata = responseObject as! Dictionary<String, Any>
                let stringaudio = dicdata["audio"] as! String
                self.play_name_date = dicdata["date"] as! String
                print(dicdata["summary"] as! String)
            
                AudioData.AddNameData(name: self.play_name_date)
                AudioData.AddAudioData(name: self.play_name_date, audio_b64: stringaudio, needcorrect: true)
                
                UserDefaults.standard.set(self.play_name_date, forKey: "DefaultAudio")
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let dest = segue.destination as! ResultVC
        dest.play_name = play_name_date
    }
    */
    
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
