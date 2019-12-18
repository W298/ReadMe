//
//  LoadVC.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/11/28.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit
import AVFoundation

class LoadVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var TableV: UITableView!
    
    struct Cell
    {
        var mainlabel = String()
        var previewlabel = String()
    }
    var data_cell = [Cell]()
    var name_ary = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Beginning Speak
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "리스트 화면입니다. 한 번 누르면 요약을 읽어주고, 항목을 오른쪽으로 스와이프하면 선택되어, 읽어주기 화면과 요약 화면에서 들을 수 있습니다.")
        
        TableV.delegate = self
        TableV.dataSource = self
        
        name_ary = AudioData.GetNameData()
        
        for name in name_ary
        {
            let str = AudioData.GetSummaryData(nameofdate: name)
            data_cell.append(Cell(mainlabel: name, previewlabel: str))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        AudioData.super_synt.stopSpeaking(at: .immediate)
        AudioData.SuperSpeak(str: "메인으로 이동합니다.")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data_cell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = TableV.dequeueReusableCell(withIdentifier: "LoadCell") as! LoadCell

        cell.tabletitle.text = data_cell[indexPath.row].mainlabel
        cell.previewlabel.text = data_cell[indexPath.row].previewlabel
        
        return cell
    }
}
