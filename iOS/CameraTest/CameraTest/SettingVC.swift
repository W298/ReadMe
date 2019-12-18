//
//  SettingVC.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/12/03.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit
import AVFoundation

class SettingVC: UITableViewController
{
    @IBOutlet weak var ReadSpeedSlider: UISlider!
    @IBOutlet weak var ModeEnabledSwitch: UISwitch!
    @IBOutlet weak var VoiceSelector: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "설정 화면입니다.")
        
        // Default Value
        if UserDefaults.standard.value(forKey: "ModeEnabled") == nil
        {
            UserDefaults.standard.set(true, forKey: "ModeEnabled")
        }
        
        if UserDefaults.standard.value(forKey: "ReadSpeed") == nil
        {
            UserDefaults.standard.set(1, forKey: "ReadSpeed")
        }
        
        if UserDefaults.standard.value(forKey: "VoiceGender") == nil
        {
            UserDefaults.standard.set(0, forKey: "VoiceGender")
        }
        
        ReadSpeedSlider.value = Float(UserDefaults.standard.value(forKey: "ReadSpeed") as! Int)
        
        ModeEnabledSwitch.setOn(UserDefaults.standard.value(forKey: "ModeEnabled") as! Bool, animated: true)
        
        VoiceSelector.selectedSegmentIndex = UserDefaults.standard.value(forKey: "VoiceGender") as! Int
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "메인으로 돌아갑니다.")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    @IBAction func SliderChange(_ sender: UISlider)
    {
        UserDefaults.standard.set(Int(round(ReadSpeedSlider.value)), forKey: "ReadSpeed")
        ReadSpeedSlider.value = Float(UserDefaults.standard.value(forKey: "ReadSpeed") as! Int)
        
        print("Changed to " + String(ReadSpeedSlider.value))
    }
    
    @IBAction func ModeChange(_ sender: UISwitch)
    {
        if UserDefaults.standard.value(forKey: "ModeEnabled") as! Bool
        {
            UserDefaults.standard.set(false, forKey: "ModeEnabled")
            
            AudioData.super_synt.stopSpeaking(at: .immediate)
            AudioData.SuperSpeak(str: "저시력자 모드가 비활성화되었습니다.")
        }
        else
        {
            UserDefaults.standard.set(true, forKey: "ModeEnabled")
            
            AudioData.super_synt.stopSpeaking(at: .immediate)
            AudioData.SuperSpeak(str: "저시력자 모드가 활성화되었습니다.")
        }
    }
    
    @IBAction func VoiceChange(_ sender: UISegmentedControl)
    {
        switch VoiceSelector.selectedSegmentIndex
        {
        case 0:
            UserDefaults.standard.set(0, forKey: "VoiceGender")
            
            AudioData.super_synt.stopSpeaking(at: .immediate)
            AudioData.SuperSpeak(str: "남성 음성으로 설정되었습니다.")
        case 1:
            UserDefaults.standard.set(1, forKey: "VoiceGender")
            
            AudioData.super_synt.stopSpeaking(at: .immediate)
            AudioData.SuperSpeak(str: "여성 음성으로 설정되었습니다.")
        case 2:
            UserDefaults.standard.set(2, forKey: "VoiceGender")
        default:
            UserDefaults.standard.set(0, forKey: "VoiceGender")
        }
    }
}
