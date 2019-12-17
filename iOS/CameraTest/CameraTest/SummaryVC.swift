//
//  SummaryVC.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/12/03.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit
import AVFoundation

class SummaryVC: UIViewController
{
    @IBOutlet weak var Text: UILabel!
    let synt = AVSpeechSynthesizer()
    
    var play_summary_name = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Beginning Speak
        AudioData.Speak(synt: synt, str: "요약 화면입니다. 화면을 탭하여 오디오를 재생하거나 멈출 수 있고, 위로 스와이프하여 10초 앞으로, 아래로 스와이프하여 10초 전으로 돌아갈 수 있습니다.")
        
        // Get Name of Summary to Play
        play_summary_name = UserDefaults.standard.value(forKey: "DefaultSummary") as! String
        
        // Init Summary String
        Text.text = AudioData.GetSummaryData(name: play_summary_name)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        synt.stopSpeaking(at: .immediate)
    }
}
