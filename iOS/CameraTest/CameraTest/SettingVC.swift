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
    
    let synt = AVSpeechSynthesizer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        AudioData.Speak(synt: synt, str: "설정 화면입니다.")
        
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
            print("Change Mode to False!")
        }
        else
        {
            UserDefaults.standard.set(true, forKey: "ModeEnabled")
            print("Change Mode to True!")
        }
    }
    
    @IBAction func VoiceChange(_ sender: UISegmentedControl)
    {
        switch VoiceSelector.selectedSegmentIndex
        {
        case 0:
            UserDefaults.standard.set(0, forKey: "VoiceGender")
        case 1:
            UserDefaults.standard.set(1, forKey: "VoiceGender")
        case 2:
            UserDefaults.standard.set(2, forKey: "VoiceGender")
        default:
            UserDefaults.standard.set(0, forKey: "VoiceGender")
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
