//
//  ResultVC.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/11/15.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class ResultVC: UIViewController, UINavigationControllerDelegate
{
    @IBOutlet weak var playbutton: UIImageView!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var durationlabel: UILabel!
    @IBOutlet weak var ProcessSlider: UISlider!
    
    var audio = Data()
    var mTimer = Timer()
    var isR: Bool = false
    
    var player = AVAudioPlayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Beginning Speak
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "읽어주기 화면입니다. 화면을 탭하여 오디오를 재생하거나 멈출 수 있고, 위로 스와이프하여 10초 앞으로, 아래로 스와이프하여 10초 전으로 돌아갈 수 있습니다.")
        
        let TapG = UITapGestureRecognizer(target: self, action: #selector(PlayAudio))
        let UpG = UISwipeGestureRecognizer(target: self, action: #selector(GoFront))
        let DownG = UISwipeGestureRecognizer(target: self, action: #selector(GoDown))
        
        UpG.direction = .up
        DownG.direction = .down
        
        view.addGestureRecognizer(TapG)
        view.addGestureRecognizer(UpG)
        view.addGestureRecognizer(DownG)
        
        if UserDefaults.standard.value(forKey: "DefaultAudio") == nil
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            audio = AudioData.GetAudioData(name: UserDefaults.standard.value(forKey: "DefaultAudio") as! String)
        }
        prepareplayer()
        
        timelabel.text = SecondsToTime(sec: 0)
        durationlabel.text = String("/ ") + SecondsToTime(sec: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        playbutton.image = UIImage(systemName: "play")
        
        player.pause()
        mTimer.invalidate()
        
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "메인으로 이동합니다.")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc func PlayAudio()
    {
        AudioData.super_synt.stopSpeaking(at: .immediate)
        
        if player.isPlaying
        {
            // Pause Audio
            playbutton.image = UIImage(systemName: "play")
            
            player.pause()
            mTimer.invalidate()
            
            isR = true
        }
        else
        {
            // Play Audio
            playbutton.image = UIImage(systemName: "pause")
        
            player.play()
            mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountTime), userInfo: nil, repeats: true)
            
            isR = false
        }
    }
    
    @objc func GoFront()
    {
        AudioData.super_synt.stopSpeaking(at: .immediate)
        
        // Go 10s Front
        player.currentTime = player.currentTime + 10
        player.play()
        mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountTime), userInfo: nil, repeats: true)
    }
    
    @objc func GoDown()
    {
        AudioData.super_synt.stopSpeaking(at: .immediate)
        
        // Go 10s Backward
        player.currentTime = player.currentTime - 10
        player.play()
        mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountTime), userInfo: nil, repeats: true)
    }
    
    @objc func CountTime()
    {
        if player.isPlaying
        {
            timelabel.text = SecondsToTime(sec: Int(player.currentTime))
            durationlabel.text = String("/ ") + SecondsToTime(sec: Int(player.duration))
            
            ProcessSlider.value = Float(player.currentTime)
        }
        else
        {
            playbutton.image = UIImage(systemName: "play")
            mTimer.invalidate()
            
            if !isR
            {
                let tempsynt = AVSpeechSynthesizer()
                AudioData.Speak(synt: tempsynt, str: "재생이 완료되었습니다.")
                
                isR = true
            }
        }
    }
    
    func prepareplayer()
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(data: audio, fileTypeHint: AVFileType.mp3.rawValue)
            
            player.enableRate = true
            player.rate = Float(UserDefaults.standard.value(forKey: "ReadSpeed") as! Int)
            
            player.prepareToPlay()

        } catch let error {
            print(error.localizedDescription)
        }
        
        ProcessSlider.minimumValue = 0
        ProcessSlider.maximumValue = Float(player.duration)
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
