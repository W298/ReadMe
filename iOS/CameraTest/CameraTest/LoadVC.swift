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
    
    let synt = AVSpeechSynthesizer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Beginning Speak
        AudioData.Speak(synt: synt, str: "리스트 화면입니다. 한 번 누르면 요약을 읽어주고, 두 번 누르면 선택되어 읽어주기 화면에서 재생할 수 있습니다.")
        
        TableV.delegate = self
        TableV.dataSource = self
        
        data_cell.append(Cell(mainlabel: "2019.11.28 9:00AM", previewlabel: "테스트1"))
        data_cell.append(Cell(mainlabel: "2019.12.1 11:00AM", previewlabel: "테스트2"))
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        synt.stopSpeaking(at: .immediate)
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
