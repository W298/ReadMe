//
//  ViewController.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/11/12.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate
{
    @IBOutlet var VCView: UIView!
    
    // Get Reference of Result View Controller
    let ResultVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultVC")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Beginning Speak
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "안녕하세요, 리드미입니다. 위로 스와이프하면 스캔 화면, 아래로 스와이프하면 리스트 화면, 오른쪽으로 스와이프하면 읽어주기 화면, 왼쪽으로 스와이프하면 요약 화면으로 이동합니다. 어느 화면에서든지 메인화면으로 돌아올려면, 왼쪽 끝에서 오른쪽으로 스와이프하면 됩니다.")
        
        // MARK: - Setup Recognizer
        // Init Swipe Gesture Recognizer
        let SwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let SwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let SwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let SwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        // Init Double Tap Recognizer
        let DoubleTap = UITapGestureRecognizer(target: self, action: #selector(GoSetting))
        
        // Setup Recognizer
        SwipeLeft.direction = .left
        SwipeRight.direction = .right
        SwipeUp.direction = .up
        SwipeDown.direction = .down
        
        DoubleTap.numberOfTapsRequired = 2
        
        // Add Recognizer to View
        view.addGestureRecognizer(SwipeLeft)
        view.addGestureRecognizer(SwipeRight)
        view.addGestureRecognizer(SwipeUp)
        view.addGestureRecognizer(SwipeDown)
        
        view.addGestureRecognizer(DoubleTap)
        
        print(UserDefaults.standard.dictionaryRepresentation().keys)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func LoadSetting(_ sender: UIBarButtonItem)
    {
        // Move to Setting VC
        self.performSegue(withIdentifier: "MainToSetting", sender: self)
    }
    
    // MARK: - Recognizer Control
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
        if (sender.direction == .left)
        {
            GoToSummaryVC()
        }
        if (sender.direction == .right)
        {
            GoToResultVC()
        }
        if (sender.direction == .up)
        {
            OpenCamera()
        }
        if (sender.direction == .down)
        {
            GoToLoadVC()
        }
    }
    
    @objc func GoSetting()
    {
        self.performSegue(withIdentifier: "MainToSetting", sender: self)
    }
    
    // MARK: - Recognizer Function
    func OpenCamera()
    {
        self.performSegue(withIdentifier: "MainToScan", sender: self)
    }
    
    func GoToLoadVC()
    {
        self.performSegue(withIdentifier: "MainToLoad", sender: self)
    }
    
    func GoToResultVC()
    {
        self.performSegue(withIdentifier: "MainToResult", sender: self)
    }
    
    func GoToSummaryVC()
    {
        self.performSegue(withIdentifier: "MainToSummary", sender: self)
    }
}
