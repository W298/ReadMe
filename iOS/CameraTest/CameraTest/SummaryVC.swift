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
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var PlayButton: UIImageView!
    
    
    var play_summary_name = String()
    var text_speech = String()
    
    var mTimer = Timer()
    var durationtime: Int = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Beginning Speak
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "요약 화면입니다. 화면을 탭하여 오디오를 재생하거나 멈출 수 있고, 위로 스와이프하여 10초 앞으로, 아래로 스와이프하여 10초 전으로 돌아갈 수 있습니다.")
        
        if UserDefaults.standard.value(forKey: "DefaultSummary") == nil
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            // Get Name of Summary to Play
            play_summary_name = UserDefaults.standard.value(forKey: "DefaultSummary") as! String

            // Get String of Summary to Play
            text_speech = AudioData.GetSummaryData(nameofdate: play_summary_name)
        }
        
        // Init Summary String
        Text.text = text_speech
        
        let TapG = UITapGestureRecognizer(target: self, action: #selector(PlayAudio))
        view.addGestureRecognizer(TapG)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "메인으로 이동합니다.")
    }
    
    @objc func PlayAudio()
    {
        AudioData.super_synt.stopSpeaking(at: .immediate)
        
        if AudioData.super_synt.isSpeaking
        {
            durationtime = 0
            TimeLabel.text = SecondsToTime(sec: 0)
            
            mTimer.invalidate()
            
            // Stop Audio
            AudioData.super_synt.pauseSpeaking(at: .immediate)
            PlayButton.image = UIImage(systemName: "play")
        }
        else
        {
            mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountTime), userInfo: nil, repeats: true)
            
            // Start At the Beginning
            AudioData.SuperSpeak(str: text_speech)
            
            PlayButton.image = UIImage(systemName: "stop")
        }
    }
    
    @objc func CountTime()
    {
        if AudioData.super_synt.isSpeaking
        {
            durationtime = durationtime + 1
            TimeLabel.text = SecondsToTime(sec: Int(durationtime))
        }
        else
        {
            let tempsynt = AVSpeechSynthesizer()
            AudioData.Speak(synt: tempsynt, str: "재생이 완료되었습니다.")
            
            durationtime = 0
            TimeLabel.text = SecondsToTime(sec: 0)
            
            PlayButton.image = UIImage(systemName: "play")
            
            mTimer.invalidate()
        }
    }
    
    func SecondsToTime(sec: Int) -> String
    {
        let min = Int(sec / 60)
        let seconds = sec - (min * 60)
        
        var min_str = String(min)
        var seconds_str = String(seconds)
        
        if min < 10
        {
            min_str = String("0") + String(min)
        }
        
        if seconds < 10
        {
            seconds_str = String("0") + String(seconds)
        }
        
        let time = min_str + ":" + seconds_str
        
        return time
    }
}
