//
//  LoadCell.swift
//  CameraTest
//
//  Created by RUKA SPROUT on 2019/11/28.
//  Copyright © 2019 RUKA SPROUT. All rights reserved.
//

import UIKit

class LoadCell: UITableViewCell
{
    @IBOutlet weak var tabletitle: UILabel!
    @IBOutlet weak var previewlabel: UILabel!
    
    var name: String = String()

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoadAudio))
        self.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func LoadAudio()
    {
        
    }

}
