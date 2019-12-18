//
//  AudioData.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/12/13.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import Foundation
import AVFoundation

class AudioData
{
    static let super_synt = AVSpeechSynthesizer()
    
    static func AddNameData(name: String)
    {
        // If Array is not Defined, Create it
        if UserDefaults.standard.value(forKey: "namelist") == nil
        {
            let a: [String] = []
            UserDefaults.standard.set(a, forKey: "namelist")
        }
        
        var ary_get = UserDefaults.standard.stringArray(forKey: "namelist")
        ary_get?.append(name)
        UserDefaults.standard.set(ary_get, forKey: "namelist")
    }

    static func GetNameData() -> [String]
    {
        // If Array is not Defined, Create it
        if UserDefaults.standard.value(forKey: "namelist") == nil
        {
            let a: [String] = []
            UserDefaults.standard.set(a, forKey: "namelist")
        }
        
        return UserDefaults.standard.stringArray(forKey: "namelist")!
    }

    static func AddAudioData(name: String, audio_b64: String, needcorrect: Bool)
    {
        if needcorrect
        {
            let starti = audio_b64.index(audio_b64.startIndex, offsetBy: 2)
            let endi = audio_b64.index(audio_b64.endIndex, offsetBy: -1)
            let audio_b64_edited = String(audio_b64[starti..<endi])
            
            let audiodata = Data(base64Encoded: audio_b64_edited)
            
            UserDefaults.standard.set(audiodata, forKey: name)
        }
        else
        {
            print(audio_b64)
            let audiodata = Data(base64Encoded: audio_b64)
            UserDefaults.standard.set(audiodata, forKey: name)
        }
    }

    static func GetAudioData(name: String) -> Data
    {
        return UserDefaults.standard.value(forKey: name) as! Data
    }
    
    static func AddSummaryData(nameofdate: String, summary: String)
    {
        UserDefaults.standard.set(summary, forKey: nameofdate + String("_summary"))
    }
    
    static func GetSummaryData(nameofdate: String) -> String
    {
        return UserDefaults.standard.value(forKey: nameofdate + String("_summary")) as! String
    }
    
    static func Speak(synt: AVSpeechSynthesizer, str:String, rate: Float = 0.5)
    {
        // Create Default Value when Data not exist (To Prevent Error)
        if UserDefaults.standard.value(forKey: "ModeEnabled") == nil
        {
            UserDefaults.standard.set(true, forKey: "ModeEnabled")
        }
        
        // Speak Only When ModeEnabled is True
        if UserDefaults.standard.value(forKey: "ModeEnabled") as! Bool
        {
            let utterance = AVSpeechUtterance(string: str)
            
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
            utterance.rate = rate
            
            synt.speak(utterance)
        }
    }
    
    static func SuperSpeak(str: String)
    {
        // Create Default Value when Data not exist (To Prevent Error)
        if UserDefaults.standard.value(forKey: "ModeEnabled") == nil
        {
            UserDefaults.standard.set(true, forKey: "ModeEnabled")
        }
        
        // Speak Only When ModeEnabled is True
        if UserDefaults.standard.value(forKey: "ModeEnabled") as! Bool
        {
            let utterance = AVSpeechUtterance(string: str)
            
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
            utterance.rate = 0.5
            
            self.super_synt.speak(utterance)
        }
    }
}
