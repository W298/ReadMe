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

    var audio = Data()
    var mTimer = Timer()
    
    var player = AVAudioPlayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        
        timelabel.text = SecondsToTime(sec: 0) + String(" / ") + SecondsToTime(sec: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        playbutton.image = UIImage(systemName: "play")
        
        player.pause()
        mTimer.invalidate()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc func PlayAudio()
    {
        if player.isPlaying
        {
            // Pause Audio
            playbutton.image = UIImage(systemName: "play")
            
            player.pause()
            mTimer.invalidate()
        }
        else
        {
            // Play Audio
            playbutton.image = UIImage(systemName: "pause")
            
            player.play()
            mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc func GoFront()
    {
        // Go 10s Front
        player.currentTime = player.currentTime + 10
        player.play()
        mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountTime), userInfo: nil, repeats: true)
    }
    
    @objc func GoDown()
    {
        // Go 10s Backward
        player.currentTime = player.currentTime - 10
        player.play()
        mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountTime), userInfo: nil, repeats: true)
    }
    
    @objc func CountTime()
    {
        timelabel.text = SecondsToTime(sec: Int(player.currentTime)) + String(" / ") + SecondsToTime(sec: Int(player.duration))
    }
    
    func prepareplayer()
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(data: audio, fileTypeHint: AVFileType.mp3.rawValue)
            
            player.prepareToPlay()

        } catch let error {
            print(error.localizedDescription)
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
