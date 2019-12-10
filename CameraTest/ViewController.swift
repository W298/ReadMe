//
//  ViewController.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/11/12.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate
{
    @IBOutlet weak var debuglabel: UILabel!
    @IBOutlet var VCView: UIView!
    
    let ResultVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultVC")
    
    var image_put: UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let SwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let SwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let SwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let SwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        let DoubleTap = UITapGestureRecognizer(target: self, action: #selector(GoSetting))
        
        SwipeLeft.direction = .left
        SwipeRight.direction = .right
        SwipeUp.direction = .up
        SwipeDown.direction = .down
        
        DoubleTap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(SwipeLeft)
        view.addGestureRecognizer(SwipeRight)
        view.addGestureRecognizer(SwipeUp)
        view.addGestureRecognizer(SwipeDown)
        
        view.addGestureRecognizer(DoubleTap)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func LoadSetting(_ sender: UIBarButtonItem)
    {
        self.performSegue(withIdentifier: "MainToSetting", sender: self)
    }
    
    
    // MARK: - Swipe Control
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
        if (sender.direction == .left)
        {
            debuglabel.text = "Left"
            GoToSummaryVC()
        }
        if (sender.direction == .right)
        {
            debuglabel.text = "Right"
            GoToResultVC()
        }
        if (sender.direction == .up)
        {
            debuglabel.text = "Up"
            OpenCamera()
        }
        if (sender.direction == .down)
        {
            debuglabel.text = "Down"
            GoToLoadVC()
        }
    }
    
    @objc func GoSetting()
    {
        self.performSegue(withIdentifier: "MainToSetting", sender: self)
    }
    
    // MARK: - Swipe Function
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
