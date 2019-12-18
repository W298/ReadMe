//
//  LoadCell.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/11/28.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit
import AVFoundation

class LoadCell: UITableViewCell
{
    @IBOutlet weak var tabletitle: UILabel!
    @IBOutlet weak var previewlabel: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PreviewSound))
        let Swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        Swipe.direction = .right
        
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(Swipe)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func PreviewSound()
    {
        AudioData.super_synt.stopSpeaking(at: .immediate)
        
        if previewlabel.text == nil
        {
            previewlabel.text = "요약을 찾을 수 없습니다."
        }
        
        AudioData.SuperSpeak(str: NumberToDate(number: tabletitle.text!) + String("의 저장본입니다."))
        AudioData.SuperSpeak(str: previewlabel.text!)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
        AudioData.super_synt.stopSpeaking(at: .immediate)
        
        if (sender.direction == .right)
        {
            UserDefaults.standard.set(tabletitle.text, forKey: "DefaultAudio")
            UserDefaults.standard.set(tabletitle.text, forKey: "DefaultSummary")
            
            AudioData.SuperSpeak(str: "선택되었습니다.")
        }
    }
    
    func NumberToDate(number: String) -> String
    {
        let yearstart = number.startIndex
        let yearend = number.index(yearstart, offsetBy: 4)
        
        let year = String(number[yearstart..<yearend])
        
        let monthstart = yearend
        let monthend = number.index(monthstart, offsetBy: 2)
        
        let month = String(number[monthstart..<monthend])
        
        let daystart = monthend
        let dayend = number.index(daystart, offsetBy: 2)
        
        let day = String(number[daystart..<dayend])
        
        let hourstart = dayend
        let hourend = number.index(hourstart, offsetBy: 2)
        
        let hour = String(number[hourstart..<hourend])
        
        let minstart = hourend
        let minend = number.index(minstart, offsetBy: 2)
        
        let min = String(number[minstart..<minend])
        
        return year + "년," + month + "월," + day + "일," + hour + "시," + min + "분"
    }
}
